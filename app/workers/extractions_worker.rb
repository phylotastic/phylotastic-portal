class ExtractionsWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(source_id, source_type, current_user_id)
    puts source_id
    puts source_type
    # puts self.jid
    
    owner = User.find_by_id(current_user_id)
    
    # call extracting service based on types of source
    case source_type
    when "ConLink"
      extracted_response = Req.get(APP_CONFIG['sv_find_names']['url'] + ConLink.find_by_id(source_id).uri)



    when "ConFile"
      file = ConFile.find_by_id(source_id)
      file_url = file.document.url
      file_url.slice!(/[?]\d*\z/)
      file_url = APP_CONFIG['domain'] + file_url
      extracted_response = Req.get(APP_CONFIG['sv_find_names']['url'] + file_url + "&engine=" + file.method.to_s) 




    when "UploadedList"
      f_path = UploadedList.find(source_id).file.path
      Zip::File.open(f_path) do |zip_file|
        # Handle entries one by one
        zip_file.each do |entry|
          # Extract to file/directory/symlink
          puts "Extracting #{entry.name}"
          el = UploadedList.extraction_location(f_path, entry.name)
          entry.extract(el)
        end

        begin
          extracted_response = UploadedList.process(owner.email, source_id)
        rescue Exception => e
          puts e
          puts e.backtrace
          extracted_response = {}
        end
      
        # Find specific entry
        # entry = zip_file.glob('*.csv').first
        # puts entry.get_input_stream.read
      end






    when "ConTaxon"
      taxon = ConTaxon.find_by_id(source_id)
      
      location = taxon.country_id.nil? ? false : true
      ncbi = taxon.has_genome_in_ncbi.nil? ? false : true
      nb_species = taxon.nb_species.nil? ? false : true
      
      if (location && ncbi)
        res_loc = Req.get(APP_CONFIG['sv_species_from_taxon_by_country']['url'] + taxon.taxon + "&country=" + Country.find(taxon.country_id).name)
        res_ncbi = Req.get(APP_CONFIG['sv_ncbi_genome']['url'] + params[:taxon])
            
        new_res = JSON.parse(res_loc.to_s)
        loc_species = new_res["species"]
        mapping = []
        
        begin
          JSON.parse(res_ncbi.to_s)["species"].each do |n|
            if loc_species.include? n
              mapping << n
            end
          end
        rescue
          mapping = []
        end
        
        new_res["species"] = mapping
        response = new_res.to_json
      elsif location
        response = Req.get(APP_CONFIG['sv_species_from_taxon_by_country']['url'] + taxon.taxon + "&country=" + Country.find(taxon.country_id).name)
      elsif ncbi
        response = Req.get(APP_CONFIG['sv_ncbi_genome']['url'] + taxon.taxon)
      else
        response = Req.get(APP_CONFIG['sv_species_from_taxon']['url'] + taxon.taxon)
      end
          
      if nb_species
        begin
          if JSON.parse(response)["species"].count >= taxon.nb_species.to_i
            species = JSON.parse(response)["species"].take(taxon.nb_species.to_i)
            new_res = JSON.parse(response)
            new_res["species"] = species
            response = new_res.to_json
          else
            taxon.update_attributes(nb_species: JSON.parse(response)["species"].count)
          end
        rescue Exception => e  
          puts e.message
          puts e.backtrace
        end
      end
      
      code = JSON.parse(response)["status_code"] rescue 0
      case code
      when 404, 204
        taxon.update_attributes(reason: response)
        extracted_response = {"scientificNames": []}
      when 200
        species = JSON.parse(response)["species"] rescue []
        faker = {scientificNames: []}
        faker[:scientificNames].concat species
        extracted_response = faker.to_json
      end








    when "OnplFile"
      extracted_response = {}
      extracted = Paperclip.io_adapters.for(OnplFile.find_by_id(source_id).document).read.split("\n")
      extracted_response["scientificNames"] = extracted.map do |n|
        n.to_s.strip.encode('UTF-8', {
          :invalid => :replace,
          :undef   => :replace,
          :replace => '?'
        })
      end
      extracted_response = extracted_response.to_json
    end
    
    # raw extraction
    extraction = source_type.constantize.find_by_id(source_id).raw_extraction
    extraction.update_attributes(extracted_names: extracted_response)
    
    resolved_response = Req.post( APP_CONFIG["sv_resolve_names"]["url"],
                                  extracted_response,
                                  :content_type => :json )
                                  
    extraction.update_attributes(species: resolved_response)
  end

end
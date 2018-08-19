class TaxonomiesController < ApplicationController
  def new
    @taxonomy = Taxonomy.new
  end

  def create
    @taxonomy = current_or_guest_user.taxonomies.build(taxonomy_params)
    if @taxonomy.save
      name = params[:name].empty? ? @taxonomy.taxon : params[:name]
      @list = @taxonomy.create_list(name: name, description: params[:description])
      
      location = @taxonomy.location.nil? ? false : true
      ncbi = @taxonomy.has_genome_in_ncbi.nil? ? false : true
      nb_species = @taxonomy.number_species.nil? ? false : true
      popularity = @taxonomy.popularity.nil? ? false : true
      
      if location
        response = Req.get(Rails.configuration.x.sv_Taxon_country_species + @taxonomy.taxon + "&country=" + Country.find(@taxonomy.country_id).name)
      elsif ncbi
        response = Req.get(Rails.configuration.x.sv_Taxon_genome_species + @taxonomy.taxon)
      elsif popularity
        if @taxonomy.number_popularity <= 0
          response = Req.get(Rails.configuration.x.sv_Taxon_popular_species + @taxonomy.taxon)
        else
          response = Req.get(Rails.configuration.x.sv_Taxon_popular_species + @taxonomy.taxon + "&num_species=" + @taxonomy.number_popularity.to_s)
        end
      else
        response = Req.get(Rails.configuration.x.sv_Taxon_all_species + @taxonomy.taxon)
      end
          
      if nb_species
        begin
          if response["species"].count >= @taxonomy.number_species.to_i
            species = response["species"].take(@taxonomy.number_species.to_i)
            new_res = response
            new_res["species"] = species
            response = new_res
          else
            @taxonomy.update_attributes(number_species: response["species"].count)
          end
        rescue Exception => e  
          puts e.message
          puts e.backtrace
        end
      end
      
      code = response["status_code"] rescue 404
      case code
      when 404, 204
        extracted_response = {}
      when 200
        if popularity
          if response["result"].count == 1
            species = response["result"][0]["popular_species"].map{|a| a["name"]} rescue []
          else
            @list.update_attributes(extracted: response.to_json)
            redirect_to list_path(@list)
            return
          end
        else
          species = response["species"] rescue []
        end
        
        if species.empty?
          flash[:warning] = "No species found from provided taxon and subset"
          redirect_to list_path(@list)
          return
        end
        
        faker = {scientificNames: []}
        faker[:scientificNames].concat species
        extracted_response = faker
      end
      
      @list.update_attributes(extracted: extracted_response.to_json)
      
      resolved_response = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                                    extracted_response.to_json,
                                    :content_type => :json )
      
      if resolved_response.empty?
        extracted_for_gnr = extracted_response
        extracted_for_gnr["fuzzy_match"]    = true
        extracted_for_gnr["multiple_match"] = false
        resolved_response = Req.post( Rails.configuration.x.sv_GNR_TNRS_wrapper,
                                      extracted_for_gnr.to_json,
                                      :content_type => :json )
      end
                                  
      if resolved_response.empty?
        error = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                          extracted_response.to_json,
                          {:content_type => :json},
                          true )
        fail_record = Failure.last.id
      end     

      @list.update_attributes(resolved: resolved_response.to_json, 
                              resolving_error: error, 
                              possible_failure_record: fail_record)   

      flash[:success] = @list.name + " list is created!"
      redirect_to list_path(@list)
    else
      render action: "new"
    end
  end
    
  def choose
    @list = current_or_guest_user.lists.select{ |l| l.id == params[:id].to_i }.first
    choose = params[:choose].to_i
    taxon = JSON.parse(@list.extracted)["result"][choose]
    species = taxon["popular_species"].map{|a| a["name"]} rescue []
    faker = {scientificNames: []}
    faker[:scientificNames].concat species
    extracted_response = faker
    @list.update_attributes(extracted: extracted_response.to_json)
    
    resolved_response = Req.post( Rails.configuration.x.sv_OToL_TNRS_wrapper,
                                  extracted_response.to_json,
                                  :content_type => :json )
                                
    @list.update_attributes(resolved: resolved_response.to_json)
    flash[:success] = @list.name + " list is created!"
    redirect_to list_path(@list)
  end
  
  private
  
    def taxonomy_params
      params.require(:taxonomy).permit(
        :taxon, :location, :country_id, :has_genome_in_ncbi, :quantity, :number_species, :popularity, :number_popularity)
    end
end

class TaxonomiesController < ApplicationController
  def new
    @taxonomy = Taxonomy.new
  end

  def create
    @taxonomy = current_or_guest_user.taxonomies.build(taxonomy_params)
    if @taxonomy.save
      name = params[:name].empty? ? @taxonomy.taxon : params[:name]
      @list = @taxonomy.create_list(name: name, description: params[:description])
      flash[:success] = @list.name + " list is created!"
      
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
          species = response["popular_species"].map{|a| a["name"]}
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
                                  
      @list.update_attributes(resolved: resolved_response.to_json)
      
      redirect_to list_path(@list)
    else
      render action: "new"
    end
  end
  
  private
  
    def taxonomy_params
      params.require(:taxonomy).permit(
        :taxon, :location, :country_id, :has_genome_in_ncbi, :quantity, :number_species, :popularity, :number_popularity)
    end
end

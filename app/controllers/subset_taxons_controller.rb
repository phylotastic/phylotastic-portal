class SubsetTaxonsController < ApplicationController
  def create
    begin 
      response = RestClient.get APP_CONFIG['sv_speciesfromtaxon']['url'] + params[:subset_taxon][:name]
    rescue Exception => e
      logger.info "Cannot get species from a taxon"
      puts e.message
      flash[:danger] = "Sorry! Service is unavailable. We will fix it soon."
      redirect_to home_path
      return
    end
    
    case JSON.parse(response)["statuscode"]
    when 404, 204
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:subset_taxon][:name]}\""
      redirect_to raw_extractions_new_from_taxon_path
    when 200
      @subset_taxon = current_user.subset_taxons.build(subset_taxon_params)
      if @subset_taxon.save
        extracted_response = convert_to_extracted_response(response)
        resolved = RestClient.post( APP_CONFIG["sv_resolvenames"]["url"],
                                    extracted_response,
                                    :content_type => :json )
        resolved = convert_format(response)
        extraction = @subset_taxon.create_raw_extraction(species: resolved)
        tree = current_user.trees.create( bg_job: "-1", 
                                          status: "resolved", 
                                          raw_extraction_id: extraction.id,
                                          description: param[:subset_taxon][:description] )
        redirect_to edit_tree_path(tree.id)
      else
        @selection_taxon = SelectionTaxon.new
        @con_taxon = ConTaxon.new
        render 'raw_extractions/new_from_taxon'
      end
    else
      logger.info response
    end
  end
  
  private
    def subset_taxon_params
      params.require(:subset_taxon).permit(:name, :country_id)
    end
end

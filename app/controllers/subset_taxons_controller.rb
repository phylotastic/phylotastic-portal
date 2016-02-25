class SubsetTaxonsController < ApplicationController
  def create
    # binding.pry
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
    when 404
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:subset_taxon][:name]}\""
      redirect_to raw_extractions_new_from_taxon_path
    when 200
      @subset_taxon = current_user.selection_taxons.build(selection_taxon_params)
      if @subset_taxon.save
        resolved = convert_format(response)
        extraction = @subset_taxon.create_raw_extraction(species: resolved)
        tree = current_user.trees.create( bg_job: "-1", 
                                          status: "resolved", 
                                          raw_extraction_id: extraction.id )
        redirect_to edit_tree_path(tree.id)
      else
        render 'raw_extractions/new_from_taxon'
      end
    else
      logger.info response
    end
  end
  
  private
    def selection_taxon_params
      params.require(:selection_taxon).permit(:name, :nb_species, :criterion)
    end
end

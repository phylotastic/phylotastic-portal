class SelectionTaxonsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    begin 
      response = RestClient.get APP_CONFIG['sv_speciesfromtaxon']['url'] + params[:selection_taxon][:name]
    rescue Exception => e
      logger.info "Cannot get species from a taxon"
      puts e.message
      flash[:danger] = "Sorry! Service is unavailable. We will fix it soon."
      redirect_to root_path
      return
    end
    
    case JSON.parse(response)["status_code"]
    when 404, 204
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:selection_taxon][:name]}\""
      redirect_to raw_extractions_new_from_taxon_path
    when 200
      @selection_taxon = current_user.selection_taxons.build(selection_taxon_params)
      if @selection_taxon.save
        extracted_response = convert_to_extracted_response(response)
        resolved = RestClient.post( APP_CONFIG["sv_resolvenames"]["url"],
                                    extracted_response,
                                    :content_type => :json)
        chosen_species = convert_to_chosen_species_format( response, 
                                                           @selection_taxon.nb_species,
                                                           @selection_taxon.criterion )
        extraction = @selection_taxon.create_raw_extraction(species: resolved)
        tree = current_user.trees.create( bg_job: "-1", 
                                          chosen_species: chosen_species,
                                          raw_extraction_id: extraction.id,
                                          description: params[:selection_taxon][:description] )
                                          
        flash[:success] = "Tree ##{params[:id]} is under constructed. We will notify you when it is ready"
        job_id = TreesWorker.perform_async(tree.id)
        tree.update_attributes( bg_job: job_id, status: "constructing")
        redirect_to trees_path
      else
        @subset_taxon = SubsetTaxon.new
        @con_taxon = ConTaxon.new
        render 'raw_extractions/new_from_taxon'
      end
    else
      logger.info response
    end
  end
  
  def destroy
    stx = current_user.selection_taxons.find(params[:id])
    if stx.nil?
      redirect_to root_path
    else 
      stx.destroy
      respond_to do |format|
        format.html { redirect_to trees_path }
        format.js
      end
    end
  end
  
  private
    def selection_taxon_params
      params.require(:selection_taxon).permit(:name, :nb_species, :criterion)
    end
end

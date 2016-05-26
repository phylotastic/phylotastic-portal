class ConTaxonsController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end

  def create
    begin 
      response = RestClient.get APP_CONFIG['sv_species_from_taxon']['url'] + params[:con_taxon][:name]
    rescue Exception => e
      logger.info "Cannot get species from a taxon"
      puts e.message
      flash[:danger] = "Sorry! Service is unavailable. We will fix it soon."
      redirect_to root_path
      return
    end
    
    code = JSON.parse(response)["status_code"] rescue 0
    case code
    when 404, 204
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:con_taxon][:name]}\""
      redirect_to raw_extractions_new_from_taxon_path
    when 200
      @con_taxon = current_user.con_taxons.build(con_taxon_params)
      if @con_taxon.save
        extracted_response = convert_to_extracted_response(response)
        resolved = Req.post( APP_CONFIG["sv_resolve_names"]["url"],
                             extracted_response,
                             :content_type => :json)

        chosen_species = convert_to_chosen_species_format(response, 0, "All")
        extraction = @con_taxon.create_raw_extraction(species: resolved)
        
        tree = current_user.trees.create( bg_job: "-1", 
                                          status: "resolved", 
                                          raw_extraction_id: extraction.id,
                                          chosen_species: chosen_species,
                                          description: params[:con_taxon][:description] )
                                            
        job_id = TreesWorker.perform_async(tree.id)
        tree.update_attributes( bg_job: job_id, status: "constructing")
        flash[:success] = "Tree ##{tree.id} is under constructed. We will notify you when it is ready"
        redirect_to trees_path
      else
        render 'raw_extractions/new_from_taxon'
      end
    else
      logger.info response
    end
  end
  
  def destroy
    ctx = current_user.con_taxons.find(params[:id])
    if ctx.nil?
      redirect_to root_path
    else 
      ctx.destroy
      respond_to do |format|
        format.html { redirect_to trees_path }
        format.js
      end
    end
  end
  
  private
    def con_taxon_params
      params.require(:con_taxon).permit(:name)
    end
    
end

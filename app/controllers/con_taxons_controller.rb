class ConTaxonsController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end

  def create
    begin 
      response = RestClient.get APP_CONFIG['sv_speciesfromtaxon']['url'] + params[:con_taxon][:name]
    rescue Exception => e
      logger.info "Cannot get species from a taxon"
      puts e.message
      flash[:danger] = "Sorry! Service is unavailable. We will fix it soon."
      redirect_to home_path
      return
    end
    
    case JSON.parse(response)["statuscode"]
    when 404
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:con_taxon][:name]}\""
      redirect_to raw_extractions_new_from_taxon_path
    when 200
      @con_taxon = current_user.con_taxons.build(con_taxon_params)
      if @con_taxon.save
        resolved = convert_to_resolved_format(response)
        chosen_species = convert_to_chosen_species_format(response)
        binding.pry
        extraction = @con_taxon.create_raw_extraction(species: resolved)
        
        tree = current_user.trees.create( bg_job: "-1", 
                                          status: "resolved", 
                                          raw_extraction_id: extraction.id,
                                          chosen_species: chosen_species )
                                            
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
  
  private
    def con_taxon_params
      params.require(:con_taxon).permit(:name)
    end
    
end

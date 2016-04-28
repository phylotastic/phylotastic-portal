class SubsetTaxonsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    if params["subset_taxon"]["has_genome_in_ncbi"] == "1"
      response = Req.get(APP_CONFIG['sv_ncbi_genome']['url'] + params[:subset_taxon][:name])
      # TODO: elsif !params["subset_taxon"]["has_genome_in_ncbi"].nil?
    else
      response = Req.get(APP_CONFIG['sv_species_from_taxon']['url'] + params[:subset_taxon][:name])
    end

    if !response
      flash[:danger] = "Sorry! Service is unavailable. We will fix it soon."
      redirect_to root_path
      return
    end

    case JSON.parse(response)["status_code"]
    when 200
      @subset_taxon = current_user.subset_taxons.build(subset_taxon_params)
      if @subset_taxon.save
        extracted_response = convert_to_extracted_response(response)
        resolved = Req.post( APP_CONFIG["sv_resolve_names"]["url"],
                             extracted_response,
                             :content_type => :json )
        extraction = @subset_taxon.create_raw_extraction(species: resolved)
        tree = current_user.trees.create( bg_job: "-1",
                                          status: "resolved",
                                          raw_extraction_id: extraction.id,
                                          description: params[:subset_taxon][:description] )
        redirect_to edit_tree_path(tree.id)
      else
        @selection_taxon = SelectionTaxon.new
        @con_taxon = ConTaxon.new
        render 'raw_extractions/new_from_taxon'
      end
    else
      logger.info response
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:subset_taxon][:name]}\""
      redirect_to raw_extractions_new_from_taxon_path
    end
  end
  
  private
    def subset_taxon_params
      params.require(:subset_taxon).permit(:name, :country_id, :has_genome_in_ncbi)
    end
end

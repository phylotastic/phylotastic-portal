class ConTaxonsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @t = ConTaxon.find(params[:id])
    @ra = @t.raw_extraction
    @resolved_names = JSON.parse(@ra.species)['resolvedNames'] rescue []
    @resolved_names = [] if !@resolved_names
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new
    @con_taxon = ConTaxon.new
  end

  def create
    location = params["location"]
    ncbi = params["has_genome_in_ncbi"]
    nb_species = params["check_nb_species"]

    if (location && ncbi)
      res_loc = Req.get(APP_CONFIG['sv_species_from_taxon_by_country']['url'] + params[:taxon] + "&country=" + Country.find(params[:country_id]).name)
      res_ncbi = Req.get(APP_CONFIG['sv_ncbi_genome']['url'] + params[:taxon])
      
      if !res_loc
        flash[:danger] = "Problem with location services"
        redirect_to new_con_taxon_path
        return
      elsif !res_ncbi
        flash[:danger] = "Problem when calling to NCBI"
        redirect_to new_con_taxon_path
        return
      end
      
      new_res = JSON.parse(res_loc)
      loc_species = new_res["species"]
      mapping = []
      JSON.parse(res_ncbi)["species"].each do |n|
        if loc_species.include? n
          mapping << n
        end
      end
      
      new_res["species"] = mapping
      response = new_res.to_json
    elsif location
      response = Req.get(APP_CONFIG['sv_species_from_taxon_by_country']['url'] + params[:taxon] + "&country=" + Country.find(params[:country_id]).name)
    elsif ncbi
      response = Req.get(APP_CONFIG['sv_ncbi_genome']['url'] + params[:taxon])
    else
      response = Req.get(APP_CONFIG['sv_species_from_taxon']['url'] + params[:taxon])
    end
    
    if !response
      flash[:danger] = "Problem with services"
      redirect_to new_con_taxon_path
      return
    end
      
    if nb_species
      if JSON.parse(response)["species"].count >= params["nb_species"].to_i
        species = JSON.parse(response)["species"].take(params["nb_species"].to_i)
        new_res = JSON.parse(response)
        new_res["species"] = species
        response = new_res.to_json
      end  
    end
    
    code = JSON.parse(response)["status_code"] rescue 0
    case code
    when 404, 204
      flash[:danger] = "#{JSON.parse(response)['message']} for \"#{params[:taxon]}\""
      redirect_to new_con_taxon_path
    when 200
      @con_taxon = current_user.con_taxons.build(con_taxon_params)
      if @con_taxon.save
        extracted_response = convert_to_extracted_response(response)
        resolved = Req.post( APP_CONFIG["sv_resolve_names"]["url"],
                             extracted_response,
                             :content_type => :json)

        extraction = @con_taxon.create_raw_extraction(species: resolved)
        redirect_to root_path
      else
        render 'raw_extractions/new_from_taxon'
      end
    else
      logger.info response
      flash[:error] = "Can not process!"
      redirect_to new_con_taxon_path
    end
  end
  
  def update
    @con_taxon = current_user.con_taxons.find_by_id(params[:id])
    if @con_taxon.update_attributes(name: params["con_taxon"]["name"])
      flash[:success] = "List name updated"
      redirect_to root_path
    else
      flash[:danger] = "Failed to update list name"
      redirect_to root_path
    end
  end
  
  def destroy
    ctx = current_user.con_taxons.find(params[:id])
    if ctx.nil?
      redirect_to root_path
    else 
      ctx.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end
  
  private
    def con_taxon_params
      params.permit(:name, :taxon, :description,  :country_id, 
                    :has_genome_in_ncbi, :nb_species)
    end
    
end

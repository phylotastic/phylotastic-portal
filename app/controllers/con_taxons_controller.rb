class ConTaxonsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create]
  
  def new
    @con_taxon = ConTaxon.new
    if !user_signed_in? && cookies[:temp_id].nil?
      redirect_to root_path
    end
  end

  def create
    if user_signed_in?
      user = current_user
      temp_id = nil
    else
      user = User.anonymous      
      if cookies[:temp_id].nil?
        redirect_to root_path
        return
      end
      temp_id = cookies[:temp_id]
    end
    
    location = params["location"]
    ncbi = params["has_genome_in_ncbi"]
    nb_species = params["check_nb_species"]
    
    if location != "true" 
      params.delete :country_id
    end
    if ncbi != "true"
      params.delete :has_genome_in_ncbi
    end
    if nb_species != "true"
      params.delete :nb_species
    end
    @con_taxon = user.con_taxons.build(con_taxon_params)
    if @con_taxon.save
      ra = @con_taxon.create_raw_extraction(temp_id: temp_id, user_id: user.id)
      flash[:success] = "Processing! Please wait a couple of seconds"
      job_id = ExtractionsWorker.perform_async(@con_taxon.id, "ConTaxon", user.id)
      redirect_to root_path(ra: ra.id, jid: job_id, waiting: 1)
    else
      render action: 'new'
    end
  end
  
  def update
    @con_taxon = current_user.con_taxons.find_by_id(params[:id])
    if @con_taxon.update_attributes(name: params["con_taxon"]["name"])
      flash[:success] = "List name updated"
      redirect_to root_path(ra: @con_taxon.raw_extraction)
    else
      flash[:danger] = "Failed to update list name"
      redirect_to root_path(ra: @con_taxon.raw_extraction)
    end
  end
  
  def destroy
    ctx = current_user.con_taxons.find(params[:id])
    if ctx.nil?
      redirect_to root_path
    else 
      flash[:info] = "#{ctx.name} is deleted"
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

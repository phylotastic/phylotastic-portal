class ConLinksController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @con_link = ConLink.new
  end
  
  def show
    @l = ConLink.find(params[:id])
    @ra = @l.raw_extraction
    @resolved_names = JSON.parse(@ra.species)['resolvedNames'] rescue []
    @resolved_names = [] if !@resolved_names
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @con_link = current_user.con_links.build(con_link_params)
    if @con_link.save
      job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", current_user.id)
      redirect_to root_path(type: "cl", id: @con_link.id)
    else
      flash[:error] = "Can not process link!"
      redirect_to new_con_link_path
    end
  end
  
  def update
    @con_link = current_user.con_links.find_by_id(params[:id])
    if @con_link.update_attributes(con_link_params)
      flash[:success] = "List name updated"
      redirect_to root_path
    else
      flash[:danger] = "Failed to update list name"
      redirect_to root_path
    end
  end
  
  def destroy
    cl = current_user.con_links.find(params[:id])
    if cl.nil?
      redirect_to root_path
    else 
      cl.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end
  
  private
    def con_link_params
      params.require(:con_link).permit(:uri, :name, :description)
    end
    
end

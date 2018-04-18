class ConLinksController < ApplicationController
  # before_action :authenticate_user!
  # skip_before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  
  
  def new
    @con_link = ConLink.new
    if !user_signed_in? && cookies[:temp_id].nil?
      redirect_to root_path
    end
  end
  
  def create
    @con_link = @user.con_links.build(con_link_params)
    if @con_link.save
      ra = @con_link.create_raw_extraction(temp_id: @temp_id, user_id: @user.id)
      flash[:success] = "Processing! Please wait a couple of seconds"
      job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", @user.id)
      redirect_to root_path(ra: ra.id, jid: job_id, waiting: 1)
    else
      render action: "new"
    end
  end
  
  def update
    @con_link = @user.con_links.find_by_id(params[:id])
    if @con_link.update_attributes(con_link_params)
      flash[:success] = "List name updated"
      redirect_to root_path(ra: @con_link.raw_extraction)
    else
      flash[:danger] = "Failed to update list name"
      redirect_to root_path(ra: @con_link.raw_extraction)
    end
  end
  
  def destroy
    cl = @user.con_links.find(params[:id])
    if cl.nil?
      redirect_to root_path
    else 
      flash[:info] = "#{cl.name} is deleted"
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

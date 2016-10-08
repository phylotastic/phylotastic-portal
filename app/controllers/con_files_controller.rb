class ConFilesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create, :show]
  
  def new
    @con_file = ConFile.new
  end
    
  def show
    if user_signed_in?
      user = current_user
    else
      user = User.anonymous      
    end
    @f = user.con_files.find(params[:id])
    @ra = @f.raw_extraction
    if @ra.nil?
      respond_to do |format|
        format.js
      end
      return
    end
    @resolved_names = JSON.parse(@ra.species)['resolvedNames'] rescue []
    @resolved_names = [] if !@resolved_names
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    if user_signed_in?
      user = current_user
    else
      user = User.anonymous      
    end
    @con_file = user.con_files.build(con_file_params)
    if @con_file.save
      flash[:success] = "Processing!"
      job_id = ExtractionsWorker.perform_async(@con_file.id, "ConFile", user.id)
      redirect_to root_path(type: "cf", id: @con_file.id, jid: job_id)
    else
      flash[:error] = "Can not process file!"
      redirect_to root_path
    end
  end
  
  def update
    @con_file = current_user.con_files.find_by_id(params[:id])
    if @con_file.update_attributes(con_file_params)
      flash[:success] = "List name updated"
      redirect_to root_path
    else
      flash[:danger] = "Failed to update list name"
      redirect_to root_path
    end
  end
  
  def destroy
    cf = current_user.con_files.find(params[:id])
    if cf.nil?
      redirect_to root_path
    else 
      flash[:info] = "#{cf.name} is deleted"
      cf.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end
  
  private
    def con_file_params
      params.fetch(:con_file, {}).permit(:document, :name, :description, :method)
    end
end

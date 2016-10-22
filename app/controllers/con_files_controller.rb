class ConFilesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create, :show]
  
  def new
    @con_file = ConFile.new
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
    @con_file = user.con_files.build(con_file_params)
    if @con_file.save
      ra = @con_file.create_raw_extraction(temp_id: temp_id, user_id: user.id)
      flash[:success] = "Processing! Please wait a couple of seconds"
      job_id = ExtractionsWorker.perform_async(@con_file.id, "ConFile", user.id)
      redirect_to root_path(ra: ra.id, jid: job_id, waiting: 1)
    else
      render action: "new"
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

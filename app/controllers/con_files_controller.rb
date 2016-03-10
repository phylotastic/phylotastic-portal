class ConFilesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @con_file = current_user.con_files.build(con_file_params)
    if @con_file.save
      flash[:success] = "Processing file!"
      job_id = ExtractionsWorker.perform_async(@con_file.id, "ConFile", current_user.id)
      current_user.trees.create(bg_job: job_id, status: "extracting")
      redirect_to trees_path
    else
      @con_link = ConLink.new
      render 'raw_extractions/new_from_file_and_web'
    end
  end
  
  def destroy
    cf = current_user.con_files.find(params[:id])
    if cf.nil?
      redirect_to root_path
    else 
      cf.destroy
      respond_to do |format|
        format.html { redirect_to trees_path }
        format.js
      end
    end
  end
  
  private
    def con_file_params
      params.fetch(:con_file, {}).permit(:document)
    end
end

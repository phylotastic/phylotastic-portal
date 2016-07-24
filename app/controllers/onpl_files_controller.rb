class OnplFilesController < ApplicationController
  def new
    @onpl_file = OnplFile.new
  end

  def show
    @f = OnplFile.find(params[:id])
    @ra = @f.raw_extraction
    @resolved_names = JSON.parse(@ra.species)['resolvedNames'] rescue []
    @resolved_names = [] if !@resolved_names
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @onpl_file = current_user.onpl_files.build(onpl_file_params)
    if @onpl_file.save
      flash[:success] = "Processing file!"
      job_id = ExtractionsWorker.perform_async(@onpl_file.id, "OnplFile", current_user.id)
      current_user.trees.create(bg_job: job_id, status: "extracting")
      redirect_to root_path
    else
      flash[:error] = "Can not process file!"
      redirect_to new_onpl_file_path
    end
  end

  def destroy
  end
  
  private
    def onpl_file_params
      params.fetch(:onpl_file, {}).permit(:document, :name, :description)
    end
end

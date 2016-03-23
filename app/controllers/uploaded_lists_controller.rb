class UploadedListsController < ApplicationController
  def create
    @uploaded_list = current_user.uploaded_list.build(uploaded_list_params)
    if @uploaded_list.save
      flash[:success] = "Processing file!"
      job_id = ListProcessingWorker.perform_async(@uploaded_list.file.path)
      # current_user.trees.create(bg_job: job_id, status: "extracting")
      redirect_to trees_path
    else
      @uploaded_list.errors.delete(:file)
      render 'raw_extractions/new_from_pre_built_examples'
    end
  end
  
  private

  def uploaded_list_params
    params.require(:uploaded_list).permit(:file)
  end
end

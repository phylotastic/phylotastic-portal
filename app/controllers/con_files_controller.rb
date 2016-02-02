class ConFilesController < ApplicationController
  def create
    @con_file = current_user.con_files.build(con_file_params)
    if @con_file.save
      flash[:success] = "Processing file!"
      TreesWorker.perform_async(@con_file.id, "ConFile")
      redirect_to root_url
    else
      flash.now[:danger] = "Could not process file"
      @con_link = ConLink.new
      render 'raw_extractions/new_from_file_and_web'
    end
  end
  
  private
    def con_file_params
      params.require(:con_file).permit(:document)
    end
end
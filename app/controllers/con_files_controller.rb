class ConFilesController < ApplicationController
  def create
    @con_file = current_user.con_links.build(con_link_params)
    if @con_file.save
      flash[:success] = "Processing file!"
      TreesWorker.perform_async(@con_link.id, "ConLink")
      redirect_to root_url
    else
      flash.now[:danger] = "Could not process file"
      @con_link = ConLink.new
      render 'raw_extractions/new_from_file_and_web'
    end
  end
  
  private
    def con_file_params
      params.require(:con_file).permit(:uri)
    end
end

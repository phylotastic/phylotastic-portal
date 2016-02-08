class ConLinksController < ApplicationController
  def create
    @con_link = current_user.con_links.build(con_link_params)
    if @con_link.save
      flash[:success] = "Processing URL!"
      job_id = ExtractionsWorker.perform_async(@con_link.id, "ConLink", current_user.id)
      current_user.trees.create(bg_job: job_id, status: "extracting")
      redirect_to trees_path
    else
      @con_file = ConFile.new
      render 'raw_extractions/new_from_file_and_web'
    end
  end
  
  private
    def con_link_params
      params.require(:con_link).permit(:uri)
    end
    
end

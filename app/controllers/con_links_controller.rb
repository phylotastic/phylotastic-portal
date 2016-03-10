class ConLinksController < ApplicationController
  before_action :authenticate_user!
  
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
  
  def destroy
    cl = current_user.con_links.find(params[:id])
    if cl.nil?
      redirect_to root_path
    else 
      cl.destroy
      respond_to do |format|
        format.html { redirect_to trees_path }
        format.js
      end
    end
  end
  
  private
    def con_link_params
      params.require(:con_link).permit(:uri)
    end
    
end

class UploadedListsController < ApplicationController
  def create
    @uploaded_list = current_user.uploaded_list.build(uploaded_list_params)
    if @uploaded_list.save
      flash[:success] = "Processing your archive file!"
      job_id = ListProcessingWorker.perform_async(current_user.email, current_user.id, @uploaded_list.id)
      redirect_to trees_path
    else
      @uploaded_list.errors.delete(:file)
      render 'raw_extractions/new_from_pre_built_examples'
    end
  end
  
  def update
    @uploaded_list = current_user.uploaded_lists.find(params[:id])
    if @uploaded_list.update_attributes(uploaded_list_params)
      flash[:success] = "Processing your archive file!"
      job_id = ListProcessingWorker.perform_async(current_user.email, current_user.id, @uploaded_list.id)
      redirect_to trees_path
    else
      flash[:danger] = "Can not re-upload file. Please try again later"
      redirect_to trees_path    
    end
  end
  
  def show
    @uploaded_list = current_user.uploaded_lists.find_by_lid(params[:id])
    @title = params[:title]
    @res = Req.get(APP_CONFIG["sv_getspeciesinlist"]["url"] + params[:id] + "&include_all=true")
    ra = @uploaded_list.raw_extraction
    @tree = current_user.trees.build(raw_extraction_id: ra.id)
    @resolved_names = JSON.parse ra.species
  end
  
  def destroy
    ul = current_user.uploaded_lists.find(params[:id])
    if ul.nil?
      redirect_to root_path
    else 
      unless ul.status
        ul.destroy
        flash[:info] = "Deleted list"
        respond_to do |format|
          format.html { redirect_to trees_path }
          format.js
        end
        return
      end
      res = Req.get(APP_CONFIG["sv_deletelist"]["url"] + "?user_id=#{current_user.id}&list_id=#{ul.lid}")
      if !res || JSON.parse(res)["status_code"] != 200
        flash[:danger] = "Can not delete list for now"
        redirect_to trees_path
      else
        ul.destroy
        flash[:info] = "Deleted list"
        respond_to do |format|
          format.html { redirect_to trees_path }
          format.js
        end
      end
    end
  end
  
  private

  def uploaded_list_params
    params.require(:uploaded_list).permit(:file, :public)
  end
end

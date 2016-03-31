class UploadedListsController < ApplicationController
  include UploadedListsHelper
  def create
    @uploaded_list = current_user.uploaded_lists.build(uploaded_list_params)
    if @uploaded_list.save
      flash[:success] = "Processing your archive file! Please wait a few second and reload browser"
      ListProcessingWorker.perform_async(current_user.email, current_user.id, @uploaded_list.id)
      redirect_to trees_path
    else
      @uploaded_list.errors.delete(:file)
      render 'raw_extractions/new_from_pre_built_examples'
    end
  end
  
  def update
    @uploaded_list = current_user.uploaded_lists.find(params[:id])
    unless params[:uploaded_list][:file].nil?
      FileUtils.rm_rf(File.dirname(@uploaded_list.file.path))
    end
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
    @uploaded_list = UploadedList.find_by_lid(params[:id])
    list = get_a_list(@uploaded_list.lid)
    @title = list["list_title"]
    @species = list["list_species"]
    @ra = @uploaded_list.raw_extraction
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
  
  def update_species
    ul = UploadedList.find(params[:id])
    s_data = {"species" => [], "user_id" => current_user.id, "list_id" => ul.lid}
    species = JSON.parse(params["species"].to_json)
    species.each do |k,v|
      next if v["remove"] == 1
      next if (v["vernacular_name"].nil? || v["scientific_name"].nil? || v["vernacular_name"].empty? || v["scientific_name"].empty?)
      v.delete("remove")
      s_data["species"] << v
    end
    response = Req.post( APP_CONFIG["sv_replacespecies"]["url"],
                         s_data.to_json,
                         {:content_type => :json} )
                         binding.pry
    if !response || JSON.parse(response)["status_code"] != 200
      flash[:danger] = "Species are not updated"
    else
      flash[:success] = "Species are updated"
    end
    redirect_to uploaded_list_path(ul.lid)
  end
  
  private

  def uploaded_list_params
    params.require(:uploaded_list).permit(:file, :public)
  end
end

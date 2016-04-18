class UploadedListsController < ApplicationController
  before_action :authenticate_user!
  
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
    @list = get_a_list(params[:id])
    @owner = User.find(1)
    # @list["list_owner"]
    # if @uploaded_list.raw_extraction.nil?
#       t = list["list_species"].map {|s| s["scientific_name"]}.join(", ")
#       found = Req.get( APP_CONFIG["sv_findnamesintext"]["url"] + t )
#       resolved = Req.post( APP_CONFIG["sv_resolvenames"]["url"], found, :content_type => :json)
#       @ra = @uploaded_list.create_raw_extraction(species: resolved)
#     else
#       @ra = @uploaded_list.raw_extraction
#     end
  end
  
  def destroy
    ul = current_user.uploaded_lists.find_by_lid(params[:id])
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
      res = Req.get(APP_CONFIG["sv_deletelist"]["url"] + "?user_id=#{current_user.email}&list_id=#{ul.lid}")
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
    s_data = {"species" => [], "user_id" => current_user.email, "list_id" => params[:id]}
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
                         
    if !response || JSON.parse(response)["status_code"] != 200
      flash[:danger] = "Species are not updated"
    else
      flash[:success] = "Species are updated"
      t = s_data["species"].map {|s| s["scientific_name"]}.join(", ")
      found = Req.get( APP_CONFIG["sv_findnamesintext"]["url"] + t )
      resolved = Req.post( APP_CONFIG["sv_resolvenames"]["url"], found,:content_type => :json)
    end
    redirect_to uploaded_list_path(params[:id])
  end
  
  def clone
    data = get_a_list(params[:id])
    data.delete("list_id")
    data["list_species"] = []
    data["is_list_public"] = false
    
    species = JSON.parse(params["species"].to_json)
    species.each do |k,v|
      next if v["remove"] == 1
      next if (v["scientific_name"].nil? || v["scientific_name"].empty?)
      v.delete("remove")
      data["list_species"] << v
    end
    response = Req.post( APP_CONFIG["sv_createlist"]["url"],
                         { "user_id" => current_user.email,
                           "list" => data
                         }.to_json,
                         {:content_type => :json} )

    if !response || JSON.parse(response)["status_code"] != 200
      flash[:danger] = "Unable to create your list"
    else
      flash[:success] = "List created!"
      t = data["list_species"].map {|s| s["scientific_name"]}.join(", ")
      found = Req.get( APP_CONFIG["sv_findnamesintext"]["url"] + t )
      resolved = Req.post( APP_CONFIG["sv_resolvenames"]["url"], found,:content_type => :json)
    end
    redirect_to uploaded_list_path(JSON.parse(response)["list_id"])
  end
  
  private

  def uploaded_list_params
    params.require(:uploaded_list).permit(:file, :public)
  end
end

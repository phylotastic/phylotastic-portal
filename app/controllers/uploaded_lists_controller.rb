class UploadedListsController < ApplicationController
  before_action :authenticate_user!
  
  include UploadedListsHelper
  def create
    @uploaded_list = current_user.uploaded_lists.build(uploaded_list_params)
    if @uploaded_list.save
      flash[:success] = "Processing your archive file"
      ListProcessingWorker.perform_async(current_user.email, @uploaded_list.id)
      
      @uploaded_list = UploadedList.new
      res = Req.get(APP_CONFIG["sv_get_private_lists"]["url"] + "?user_id=" + current_user.email + "&access_token=" + current_user.access_token)
      @my_lists = JSON.parse(res)["lists"] rescue []
    
      res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
      @public_lists = JSON.parse(res)["lists"] rescue []
      
      render 'raw_extractions/new_from_pre_built_examples'
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
      job_id = ListProcessingWorker.perform_async(current_user.email, @uploaded_list.id)
      redirect_to trees_path
    else
      flash[:danger] = "Can not re-upload file. Please try again later"
      redirect_to trees_path    
    end
  end
  
  def show
    @list = get_a_list(params[:id])
    if @list["status_code"] == 200 # if there is a list in the service
      @uploaded_list = UploadedList.find_or_create(@list)
      @ra = @uploaded_list.raw_extraction
    else
      flash[:danger] = "No list found"
      redirect_to root_path
    end
    
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
      res = remove_private_list(ul.lid)
      binding.pry
      if res["status_code"] != 200
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
    current_user.refresh_token_if_expired
    s_data = { "species" => [], 
               "user_id" => current_user.email, 
               "list_id" => params[:id],
               "access_token" => current_user.access_token }
    species = JSON.parse(params["species"].to_json)
    species.each do |k,v|
      next if v["remove"] == 1
      next if (v["vernacular_name"].nil? || v["scientific_name"].nil? || v["vernacular_name"].empty? || v["scientific_name"].empty?)
      v.delete("remove")
      s_data["species"] << v
    end
    response = Req.post( APP_CONFIG["sv_replace_species"]["url"],
                         s_data.to_json,
                         {:content_type => :json} )
                         
    if !response || JSON.parse(response)["status_code"] != 200
      flash[:danger] = "Species are not updated"
    else
      flash[:success] = "Species are updated"
      t = s_data["species"].map {|s| s["scientific_name"]}.join(", ")
      found = Req.get( APP_CONFIG["sv_find_names_in_text"]["url"] + t )
      resolved = Req.post( APP_CONFIG["sv_resolve_names"]["url"], found,:content_type => :json)
    end
    redirect_to uploaded_list_path(params[:id])
  end
  
  def clone
    data = get_a_list(params[:id])["list"]
    data.delete("list_id")
    data["list_species"] = []
    data["is_list_public"] = params["public"].nil? ? false : true
    data["list_title"] = params["title"]

    species = JSON.parse(params["species"].to_json)
    species.each do |k,v|
      next if v["remove"] == 1
      next if (v["scientific_name"].nil? || v["scientific_name"].empty?)
      v.delete("remove")
      data["list_species"] << v
    end
    response = Req.post( APP_CONFIG["sv_create_list"]["url"],
                         { "user_id" => current_user.email,
                           "list" => data
                         }.to_json,
                         {:content_type => :json} )

    if !response || JSON.parse(response)["status_code"] != 200
      flash[:danger] = "Unable to clone"
    else
      flash[:success] = "List cloned!"
    end
    redirect_to raw_extractions_new_from_pre_built_examples_path
  end
  
  def list_content
    @list = get_a_list(params[:list_id])
    @uploaded_list = UploadedList.find_or_create(@list)
    respond_to do |format|
      format.js
    end
  end
  
  def trees
    @list = get_a_list(params["list_id"])
    uploaded_list = UploadedList.find_or_create(@list)
    if current_user.owned? @list
      @tree_ids = uploaded_list.raw_extraction.trees.map {|t| t.id }
    else
      @tree_ids = uploaded_list.raw_extraction.trees.select {|t| t.user == current_user}.map {|t| t.id }
    end
    respond_to do |format|
      format.js
    end
  end
  
  private

  def uploaded_list_params
    params.require(:uploaded_list).permit(:file, :public)
  end
end

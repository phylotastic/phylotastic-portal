require 'zip'

class UploadedListsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: :show_public
  
  include UploadedListsHelper
  include RawExtractionsHelper
  
  def new
    @uploaded_list = UploadedList.new
  end
  
  def create
    @uploaded_list = current_user.uploaded_lists.build(uploaded_list_params)
    if @uploaded_list.save
      ra = @uploaded_list.create_raw_extraction(user_id: current_user.id)
      flash[:success] = "Processing! Please wait a couple of seconds"
      job_id = ExtractionsWorker.perform_async(@uploaded_list.id, "UploadedList", current_user.id)
      redirect_to root_path(ra: ra.id, jid: job_id, waiting: 1)
    else
      render action: "new"
    end
  end
  
  def update
    uploaded_list = current_user.uploaded_lists.find(params[:id])
    unless params[:uploaded_list][:file].nil?
      FileUtils.rm_rf(File.dirname(uploaded_list.file.path))
    end
    if uploaded_list.update_attributes(uploaded_list_params)
      ra = uploaded_list.raw_extraction
      flash[:success] = "Processing! Please wait a couple of seconds"
      job_id = ExtractionsWorker.perform_async(uploaded_list.id, "UploadedList", current_user.id)
      redirect_to root_path(ra: ra.id, jid: job_id, waiting: 1)
    else
      flash[:danger] = "Can not re-upload file. Please try again later"
      redirect_to root_path(ra: ra.id)
    end
  end
  
  def update_metadata
    @uploaded_list = current_user.uploaded_lists.find_by_lid(params[:id])
    data = {}
    data["user_id"] = current_user.email
    current_user.refresh_token_if_expired
    data["access_token"] = current_user.access_token
    data["list_id"] = @uploaded_list.lid
    data["list"] = {}
    data["list"]["list_title"] = params["uploaded_list"]["name"]
    data["list"]["is_list_public"] = params["public"].downcase == 'true' ? true : false
    if !@uploaded_list.nil?
      response = Req.post( APP_CONFIG["sv_update_metadata_list"]["url"],
                         data.to_json,
                         {:content_type => :json} )

      if !response || JSON.parse(response)["status_code"] != 200
        flash[:danger] = "Failed to update list name"
        redirect_to root_path(ra: @uploaded_list.raw_extraction)
      else
        @uploaded_list.update_attributes(public: data["list"]["is_list_public"], name: data["list"]["list_title"])
        flash[:success] = "List name updated"
        redirect_to root_path(ra: @uploaded_list.raw_extraction)
      end
    else
      flash[:danger] = "Permission denied!"
      redirect_to root_path(ra: @uploaded_list.raw_extraction)
    end
  end
  
  def show_public
    @list = get_a_public_list(params[:id])
    if @list["list"]["is_list_public"]
      @uploaded_list = UploadedList.find_or_create(@list)
      @ra = @uploaded_list.raw_extraction
      @uploaded_list.update_attributes(name: @list["list"]["list_title"])
      
      respond_to do |format|
        format.js
      end
    else
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
          format.html { redirect_to root_path }
          format.js
        end
        return
      end
      res = remove_private_list(ul.lid)
      if res["status_code"] != 200
        flash[:danger] = "Can not delete list for now"
        redirect_to trees_path
      else
        ul.destroy
        flash[:info] = "Deleted list"
        respond_to do |format|
          format.html { redirect_to root_path }
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
    species = JSON.parse(params["species"].to_json) rescue []
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
      flash[:danger] = "Species are not updated " + JSON.parse(response)["message"]
    else
      flash[:success] = "Species are updated"
      t = s_data["species"].map {|s| s["scientific_name"]}.join(", ")
      found = Req.get( APP_CONFIG["sv_find_names_in_text"]["url"] + t )
      resolved = Req.post( APP_CONFIG["sv_resolve_names"]["url"], found,:content_type => :json)
    end
    redirect_to uploaded_list_path(params[:id])
  end
  
  def update_a_species
    current_user.refresh_token_if_expired
    s_data = { "species" => [], 
               "user_id" => current_user.email, 
               "list_id" => params[:id],
               "access_token" => current_user.access_token }
    @list = get_a_list(params[:id])
    species = @list["list"]["list_species"]
    subject = JSON.parse(params["species"].to_json).values.first
    species.each do |s|
      if s["scientific_name"] == subject["old"]
        s["scientific_name"] = subject["scientific_name"]
      end
    end
    s_data["species"] = species

    response = Req.post( APP_CONFIG["sv_replace_species"]["url"],
                         s_data.to_json,
                         {:content_type => :json} )

    if !response || JSON.parse(response)["status_code"] != 200
      @mess = "Species are not updated " + JSON.parse(response)["message"]
      respond_to do |format|
        format.html
        format.js
      end
    else
      names = s_data["species"].map {|s| s["scientific_name"]}
      found = Req.get( APP_CONFIG["sv_find_names_in_text"]["url"] + names.join(", ") )
      resolved_req = Req.post( APP_CONFIG["sv_resolve_names"]["url"], found,:content_type => :json)

      @ra = UploadedList.find_by_lid(params[:id]).raw_extraction
      @ra.update_attributes(species: resolved_req)
      @resolved_names = JSON.parse(resolved_req)["resolvedNames"] rescue []
      @resolved_names = [] if !resolved_req
      
      @unresolved = unresolved_filter(names, @resolved_names)
      
      if @unresolved.include? subject["scientific_name"]
        @mess = "#{subject["scientific_name"]} is unresolvable"
      else
        @mess = "#{subject["scientific_name"]} is updated in resolved table"
      end
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
  
  private

  def uploaded_list_params
    params.fetch(:uploaded_list, {}).permit(:file, :public, :name, :description)
  end

end

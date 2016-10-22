class OnplFilesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create, :show]

  def new
    @onpl_file = OnplFile.new
    if !user_signed_in? && cookies[:temp_id].nil?
      redirect_to root_path
    end
  end
  
  def create
    if user_signed_in?
      user = current_user
      temp_id = nil
    else
      user = User.anonymous      
      if cookies[:temp_id].nil?
        redirect_to root_path
        return
      end
      temp_id = cookies[:temp_id]
    end
    @onpl_file = user.onpl_files.build(onpl_file_params)
    if @onpl_file.save
      ra = @onpl_file.create_raw_extraction(temp_id: temp_id, user_id: user.id)
      flash[:success] = "Processing! Please wait a couple of seconds"
      job_id = ExtractionsWorker.perform_async(@onpl_file.id, "OnplFile", user.id)
      redirect_to root_path(ra: ra.id, jid: job_id, waiting: 1)
    else
      render action: "new"
    end
  end
  
  def update_a_species
    @f = OnplFile.find(params[:id])
    species = JSON.parse(@f.raw_extraction.extracted_names)["scientificNames"]
    subject = JSON.parse(params["species"].to_json).values.first
    changed_species = []
    species.each do |s|
      if s == subject["old"]
        changed_species << subject["scientific_name"]
      else
        changed_species << s
      end
    end

    extracted = {}
    extracted["scientificNames"] = changed_species
    resolved_response = Req.post( APP_CONFIG["sv_resolve_names"]["url"],
                                  extracted.to_json,
                                  :content_type => :json )
    if !resolved_response || JSON.parse(resolved_response)["status_code"] != 200
      @mess = "Species are not updated " + JSON.parse(response)["message"]
      respond_to do |format|
        format.html
        format.js
      end
    else
      @ra = @f.raw_extraction
      @ra.update_attributes(species: resolved_response, extracted_names: extracted.to_json)
      @resolved_names = JSON.parse(resolved_response)["resolvedNames"] rescue []
      @resolved_names = [] if !resolved_response
      
      @unresolved = []
      changed_species.each do |n|
        flag = false
        @resolved_names.each do |r|
          if r["matched_name"] == n
            flag = true 
            break
          end
        end
        @unresolved << n if !flag
      end
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
  
  def update
    @onpl_file = current_user.onpl_files.find_by_id(params[:id])
    if @onpl_file.update_attributes(onpl_file_params)
      flash[:success] = "List name updated"
      redirect_to root_path
    else
      flash[:danger] = "Failed to update list name"
      redirect_to root_path
    end
  end
  
  def destroy
    of = current_user.onpl_files.find(params[:id])
    if of.nil?
      redirect_to root_path
    else
      flash[:info] = "#{of.name} is deleted"
      of.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end
  
  private
    def onpl_file_params
      params.fetch(:onpl_file, {}).permit(:document, :name, :description)
    end
end

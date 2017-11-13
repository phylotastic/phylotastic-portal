require 'csv'
require 'rest-client'

class TreesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:show_public, :create, :index, :status,
                                                 :checking_status, :show, :newick, :update,
                                                 :scaling_sdm, :scaling_mediam]
  
  include UploadedListsHelper
  include TreesHelper
  include Tubesock::Hijack
  
  def create
    params["tree"]["chosen_species"] = params["tree"]["chosen_species"].to_json
    if user_signed_in?
      @tree = current_user.trees.build(tree_params.merge(temp_id: nil))
    else
      @tree = User.anonymous.trees.build(tree_params.merge(temp_id: cookies[:temp_id]))
    end
    if @tree.save
      job_id = TreesWorker.perform_async(@tree.id)
      @tree.update_attributes( bg_job: job_id,
                               status: "extracting",
                               notifiable: true )

      render status_trees_path
      return
    else
      render root_path
    end
  end
  
  def show
    @tree = Tree.find_by(id: params[:id])
    @id = params[:id]
    @resolved_names = JSON.parse(@tree.raw_extraction.species)["resolvedNames"] rescue []
    @last_state = params[:last_state].nil? ? false : true
    if @tree.nil? 
      redirect_to root_url
      return
    elsif @tree.status == "unsuccessfully-extracted"
      respond_to do |format|
        format.html
        format.js { render 'show_fail' }
      end
      return
    elsif @tree.status != "completed" && @tree.status != "unsuccessfully-scaled"
      flash[:danger] = "Tree is not ready to view"
      redirect_to trees_path
      return
    else
      if !@tree.public
        if @tree.user.email != APP_CONFIG['anonymous']
          if @tree.user != current_user
            redirect_to root_path
            return
          end
        end
      end
    end
    respond_to do |format|
      begin
        # generate workflow explanation
        response = RestClient.post( APP_CONFIG["gf_server"],
          {
            :file => @tree.workflow
          })
        @explanation = JSON.parse(response)
      rescue => e
        @explanation = nil
      end
      format.js
    end
  end
  
  def index
    @inspect = params[:ins]
    if user_signed_in?
      if current_user.sign_in_count == 1
        if cookies[:view_hint].nil?
          cookies[:view_hint] = "true"
        end
        if cookies[:view_hint] == "false"
          cookies[:view_hint] = "true"
          current_user.update_attributes(sign_in_count: 2)
        end
      end
      trees = current_user.trees
      @my_trees = trees.to_a
    else
      if cookies[:view_hint].nil?
        cookies[:view_hint] = "true"
      end
      @my_trees = Tree.where(temp_id: cookies[:temp_id])
    end
    
    @my_trees = @my_trees.to_a.sort_by {|t| t.name.nil? ? "" : t.name.downcase }
    @public_trees = Tree.all.select {|t| t.public }.sort_by! {|t| t.name.downcase }
  end
    
  def update
    @tree = current_user.trees.find_by_id(params[:id])
    @action_updated = false
    unless tree_params[:action_sequence].nil?
      @action_updated = true
    end
    if @tree.update_attributes(tree_params)
      respond_to do |format|
        format.html { 
          flash[:success] = "Updated tree information"
          redirect_to trees_path(ins: params[:id])
        }
        format.js
      end
    else
      flash[:danger] = "Cannot save tree info"
      redirect_to trees_path(ins: params[:id])
    end
  end
  
  def status
    if @tree.nil?
      redirect_to trees_path
    end
  end
  
  def checking_status
    if user_signed_in?
      @tree = current_user.trees.find_by_id(params[:id])
    else
      @tree = User.anonymous.trees.find_by_id(params[:id])
    end
    job_id = @tree.bg_job
    hijack do |tubesock|
      while Sidekiq::Status::queued? job_id
        sleep 1
        data = {status: "queue", pct: 0}.to_json
        tubesock.send_data data
      end
      while Sidekiq::Status::working? job_id
        sleep 1        
        pct = Sidekiq::Status::pct_complete job_id
        data = {status: "working", pct: pct}.to_json
        tubesock.send_data data
      end
    
      if Sidekiq::Status::complete? job_id
        case Tree.find(@tree.id).status
        when "unsuccessfully-extracted"
          data = {status: "failed", pct: 0}.to_json
        when "unsuccessfully-scaled", "completed"
          data = {status: "complete", pct: 100}.to_json
        end
        tubesock.send_data data
      end
    
      if Sidekiq::Status::failed? job_id
        data = {status: "failed", pct: 0}.to_json
        tubesock.send_data data
      end
    
      if Sidekiq::Status::interrupted? job_id
        pct = Sidekiq::Status::pct_complete job_id
        data = {status: "interrupted", pct: pct}.to_json
        tubesock.send_data data
      end
    end
  end
  
  def destroy
    tree = Tree.find(params[:id])
    if tree.nil?
      redirect_to root_path
    else 
      tree.destroy
      respond_to do |format|
        format.html { redirect_to trees_path }
        format.js
      end
    end
  end
  
  def newick
    @tree = Tree.find(params[:id])
    if @tree.nil?
      redirect_to root_path
    else 
      if params[:ott] == "true"
        send_data JSON.parse(@tree.representation)['newick'], :filename => @tree.name + "_newick.txt"
      else
        send_data sanitize_newick(@tree), :filename => @tree.name + "_newick.txt"
      end
    end
  end
  
  def scaling_mediam
    @tree = Tree.find(params[:id])
    if !@tree.scaled_representation.nil?
      if JSON.parse(@tree.scaled_representation.to_s).has_key?("scaled_tree")
        respond_to do |format|
          format.js
        end
        return
      end
    end
    
    begin
      scaled_response = Req.post( APP_CONFIG["sv_datelife_tree"]["url"],
                                  {"newick": sanitize_newick(@tree), method: "median"}.to_json,
                                  :content_type => :json, 
                                  :accept => :json )
    rescue => e
      puts e
      logger.info "Call service error"
    end
    
    if !scaled_response
      @tree.update_attributes( status: "unsuccessfully-scaled", 
                              bg_job: "-1",
                              scaled_representation: nil )
    elsif JSON.parse(scaled_response)["message"] == "Success" 
      scaled_response = scaled_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "completed", 
                              bg_job: "-1",
                              scaled_representation: scaled_response )
      respond_to do |format|
        format.js
      end
      return
    else
      scaled_response = scaled_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-scaled", 
                              bg_job: "-1",
                              scaled_representation: scaled_response )
    end
    
    respond_to do |format|
      format.js { render 'scaling_failed.js.erb' }
    end
    
  end
  
  def scaling_sdm
    @tree = Tree.find(params[:id])
    if !@tree.scaled_sdm_representation.nil?
      if JSON.parse(@tree.scaled_sdm_representation).has_key?("scaled_tree")
        respond_to do |format|
          format.js
        end
        return
      end
    end
    
    begin
      scaled_response = Req.post( APP_CONFIG["sv_datelife_tree"]["url"],
                                  {"newick": sanitize_newick(@tree), method: "sdm"}.to_json,
                                  :content_type => :json, 
                                  :accept => :json )
    rescue => e
      puts e
      logger.info "Call service error"
    end
    
    if !scaled_response
      @tree.update_attributes( status: "unsuccessfully-scaled", 
                              bg_job: "-1",
                              scaled_sdm_representation: nil )
    elsif JSON.parse(scaled_response)["message"] == "Success" 
      scaled_response = scaled_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "completed", 
                              bg_job: "-1",
                              scaled_sdm_representation: scaled_response )
      respond_to do |format|
        format.js
      end
      return
    else
      scaled_response = scaled_response.to_s.gsub('\'', '')
      @tree.update_attributes( status: "unsuccessfully-scaled", 
                              bg_job: "-1",
                              scaled_sdm_representation: scaled_response )
    end
    
    respond_to do |format|
      format.js { render 'scaling_failed.js.erb' }
    end
  end
  
  private
    def tree_params
      params.require(:tree).permit(:phylo_source_id, :branch_length, 
                                   :images_from_EOL, :image, :public, 
                                   :raw_extraction_id, :chosen_species,
                                   :description, :name, :action_sequence)
    end
end

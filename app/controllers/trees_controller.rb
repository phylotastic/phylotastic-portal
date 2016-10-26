require 'csv'

class TreesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:show_public, :create, :index, :checking_status, :show, :newick, :taxon_matching_report]
  
  include UploadedListsHelper
  include TreesHelper
  include Tubesock::Hijack
  
  def create
    if cookies[:welcome].nil?
      cookies[:welcome] = 1
    end
    params["tree"]["chosen_species"] = params["tree"]["chosen_species"].to_json
    if user_signed_in?
      @tree = current_user.trees.build(tree_params.merge(temp_id: nil))
    else
      @tree = User.anonymous.trees.build(tree_params.merge(temp_id: cookies[:temp_id]))
    end
    if @tree.save
      job_id = TreesWorker.perform_async(@tree.id)
      @tree.update_attributes( bg_job: job_id,
                               status: "constructing",
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
    if @tree.nil? 
      redirect_to root_url
      return
    elsif @tree.status == "unsuccessfully-constructed"
      respond_to do |format|
        format.html
        format.js { render 'show_fail' }
      end
      return
    elsif @tree.status != "completed"
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
      format.html
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
    
    if params[:hot]
      @hot = true
    else
      @hot = false
    end

    if params[:failed]
      @failed = true
    else
      @failed = false
    end
    
    @my_trees = @my_trees.to_a.sort_by {|t| t.name.nil? ? "" : t.name.downcase }
    @public_trees = Tree.all.select {|t| t.public }.sort_by! {|t| t.name.downcase }
  end
    
  def update
    @tree = current_user.trees.find_by_id(params[:id])
    if @tree.update_attributes(tree_params)
      flash[:success] = "Updated tree information"
      redirect_to trees_path(ins: params[:id])
    else
      flash[:danger] = "Cannot save tree info"
      redirect_to trees_path(ins: params[:id])
    end
  end
  
  def status
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
        if Tree.find(@tree.id).status == "unsuccessfully-constructed"
          data = {status: "failed", pct: 0}.to_json
        elsif Tree.find(@tree.id).status == "completed"
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
  
  
  private
    def tree_params
      params.require(:tree).permit(:phylo_source_id, :branch_length, 
                                   :images_from_EOL, :image, :public, 
                                   :raw_extraction_id, :chosen_species,
                                   :description, :name)
    end
end

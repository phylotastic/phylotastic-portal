require 'csv'

class TreesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: :show_public
  
  include UploadedListsHelper
  include TreesHelper
  include Tubesock::Hijack
  
  def new
    @ra = RawExtraction.find(params[:ra])
    source = @ra.contributable
    if source.class.name != "UploadedList"
      if source.user != current_user 
        flash[:danger] = "Permission denied!"
        redirect_to root_path
        return
      end
    else
      list = get_a_list(source.lid)
      if source.public
        unless current_user.owned?(list)
          current_user.subcribe(source)
        end
      else
        unless current_user.owned?(list)
          flash[:danger] = "Permission denied!"
          redirect_to root_path
          return
        end
      end
    end

    @tree = current_user.trees.build(raw_extraction_id: params[:ra])
    @resolved_names = JSON.parse @ra.species rescue []
  end
  
  def create    
    params["tree"]["chosen_species"] = params["tree"]["chosen_species"].to_json
    @tree = current_user.trees.build(tree_params)
    if @tree.save
      job_id = TreesWorker.perform_async(@tree.id)
      @tree.update_attributes( bg_job: job_id,
                               status: "constructing",
                               notifiable: true )

      render status_trees_path
      return
    else
      render 'static_pages/home'
    end
  end
  
  def show
    @tree = Tree.find_by(id: params[:id])
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
        if @tree.user != current_user
          redirect_to root_path
          return
        end
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def index
    # @con_link_jobs        = current_user.con_links
#     @con_file_jobs        = current_user.con_files
#     @con_taxon_jobs       = current_user.con_taxons
#     @selection_taxon_jobs = current_user.selection_taxons.reverse
#     @subset_taxon_jobs    = current_user.subset_taxons.reverse
#
#     @my_lists = get_private_lists["lists"] rescue []
#     @my_failed_lists = current_user.failed_lists
#     @my_subcribing_lists = current_user.subcribing_lists
#
#     @processing = current_user.processing_trees
    @inspect = params[:ins]
    trees = current_user.trees
    @my_trees = trees.select {|t| !t.public }.sort_by! {|t| t.name}
    @public_trees = trees.select {|t| t.public }.sort_by! {|t| t.name}
  end
    
  def edit
    @tree = current_user.trees.find_by_id(params[:id])
    @ra = @tree.raw_extraction
    @resolved_names = JSON.parse @ra.species rescue []
  end
  
  def update
    @tree = current_user.trees.find_by_id(params[:id])
    if @tree.update_attributes(tree_params)
      respond_to do |format|
        format.html { redirect_to tree_path(params[:id]) }
        format.js { render 'update.js.erb'}
      end
    else
      flash[:danger] = "Cannot save tree info"
      redirect_to tree_path(params[:id])
    end
  end
  
  def status
  end
  
  def checking_status
    @tree = current_user.trees.find_by_id(params[:id])
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
        data = {status: "complete", pct: 100}.to_json
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
  
  def generate_image
    respond_to do |format|
      format.svg {
        send_data(params["image"], disposition: 'attachment')
      }
    end
  end
  
  def public
    @tree = current_user.trees.find_by_id(params[:id])
    if @tree.update_attributes(tree_params)
      respond_to do |format|
        format.html { redirect_to public_gallery_trees_path }
        format.js { render 'public.js.erb'}
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
  
  def public_gallery
    @trees = Tree.search do
      all do 
        fulltext params[:search]
        with(:public, true)
        paginate :page => params[:page], :per_page => 9
      end
    end.results
  end
  
  def image_getter
    data = Req.get(APP_CONFIG["sv_get_species_image"]["url"] + params["spe"])
    res = JSON.parse(data) rescue []
    # image_url = res["species"].first["images"].first["eolThumbnailURL"]
    image_url = res["species"].first["images"].first["eolMediaURL"]
    image = Base64.encode64(open(image_url, "rb").read)
    respond_to do |format|
      format.json { render :json => {image: "data:image/png;base64,#{image}"} }
    end
  end
  
  def taxon_matching_report
    ra = RawExtraction.find(params[:ra])
    @resolved_names = JSON.parse(ra.species)["resolvedNames"] rescue []
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "taxon_matching_report",
               template: "trees/taxon_matching_report.pdf.erb"
      end
     format.csv do
       render csv: "taxon_matching_report",
              template: "trees/taxon_matching_report.csv.erb"
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
  
  def update_description
    @tree = current_user.trees.find_by_id(params[:id])
    if @tree.nil?
      redirect_to root_path
    else
      @tree.update_attributes(description: params[:description])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
  
  def download_image
    tree = current_user.trees.find_by_id(params[:id])
    if tree.nil?
      redirect_to root_path
    else
      send_file tree.image.path
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

class TreesController < ApplicationController
  include TreesHelper
  include ListsHelper
  
  before_action :find_tree, only: [:destroy, :edit, :update, :show, :download, :metadata, :download_tree_info]

  def show
    @x = params[:x]
    
    if cookies[:view_hint].nil?
      cookies[:view_hint] = { :value => "true", :expires => 1.month.from_now }
    end
    
    if @tree.nil?
      redirect_to root_path
      return
    end
       
    @display_scale = false 
    if params[:method] == "scaled_sdm"
      @newick = @tree.sdm_scaled
      @display_scale = true
    elsif params[:method] == "scaled_median"
      @newick = @tree.median_scaled
      @display_scale = true
    elsif params[:method] == "scaled_ot"
      @newick = @tree.ot_scaled
      @display_scale = true
    else
      begin
        @newick = @tree.unscaled
      rescue
        redirect_to root_path
        return
      end
    end
    
    if @tree.list_from_service
      @list = get_a_list_from_service(@tree.list_id)
      @list_name = @list["list"]["list_title"]
      @link_to_list = list_path(@tree.list_id, from_service: true)
    else
      # remove trees associated with deleted list
      begin
        @list = List.find(@tree.list_id)
      rescue
        @tree.destroy
        redirect_to root_path
        return
      end
      
      @list_name = @list.name
      if @list.nil?
        @link_to_list = nil
      else
        @link_to_list = list_path(@list)
      end
    end
    
    # scale tree
    unless @tree.unscaled.empty?
      if @tree.scaled_sdm.nil?
        sdm_job_id = SdmScalingWorker.perform_async(@tree.id)
        @tree.update_attributes(scaled_sdm_job_id: sdm_job_id)
      end
      if @tree.scaled_median.nil?
        median_job_id = MedianScalingWorker.perform_async(@tree.id)
        @tree.update_attributes(scaled_median_job_id: median_job_id)
      end
      if @tree.scaled_ot.nil?
        ot_job_id = OtScalingWorker.perform_async(@tree.id)
        @tree.update_attributes(scaled_ot_job_id: ot_job_id)
      end
    end
    
    # get common names for tree tips
    if @tree.list.nil? || @tree.list.resource.class.name == "Cn"
      return
    end
    
    if @tree.common_name_tips[:tip_list].empty?
      cn_id = CommonNameWorker.perform_async(@tree.id)
      @tree.update_attributes(common_name_mapping_job_id: cn_id)
    end
    
  end

  def create
    @tree = current_or_guest_user.trees.build(tree_params.merge(list_id: params[:list_id]))
    species = params[:tree][:species]
    @tree.species = species.to_json
    chosen_species = species.select { |x| species[x] == "1" }.keys
    
    if chosen_species.count < 2
      flash[:danger] = "We need at least 2 names for tree extraction"
      if tree_params[:list_from_service] == "true"
        redirect_to list_path(id: params[:list_id], from_service: true)
      else
        redirect_to list_path(id: params[:list_id])
      end
      return
    end
    
    extracted_response = Req.post( Rails.configuration.x.sv_OToL_wrapper_Tree,
                                     {
                                       "taxa": chosen_species
                                       # ,
                                       # "metadata": true
                                     }.to_json,
                                     :content_type => :json,
                                     :accept => :json )
    
    if extracted_response.empty?
      extracted_response = Req.post( Rails.configuration.x.sv_Phylomatic_wrapper_Tree,
                                    {
                                      "taxa": chosen_species
                                      # ,
                                      # "metadata": true
                                    }.to_json,
                                       :content_type => :json,
                                       :accept => :json )
    end
    
    if extracted_response.empty?
     @tree.error = Req.post( Rails.configuration.x.sv_OToL_wrapper_Tree,
                                     {
                                       "taxa": chosen_species
                                       # ,
                                       # "metadata": true
                                     }.to_json,
                                     { 
                                       :content_type => :json,
                                       :accept => :json
                                     },
                                     true )
     @tree.possible_failure_record = Failure.last.id
    end

    @tree.tree = extracted_response.to_json
    
    if @tree.save
      redirect_to @tree
    else
      redirect_to root_path
    end
  end

  def update
    @tree.update_attributes(tree_params)
    respond_to do |format|
      format.html { 
        flash[:success] = "Updated tree information"
        redirect_to @tree
      }
      format.js
    end
    
  end

  def destroy
    @tree.destroy
    flash[:success] = "Tree was removed"
    redirect_to root_path
  end
  
  def download
    if @tree.nil?
      redirect_to root_path
    else 
      if params[:ott] == "true"
        send_data @tree.unscaled, :filename => @tree.name + "_newick.txt"
      else
        send_data sanitize_newick(@tree.unscaled), :filename => @tree.name + "_newick.txt"
      end
    end
  end
  
  def wf
    @tree = Tree.first
    workflow = File.new( Rails.root.join('app', 'views', 'trees', "workflow_plan_1.json"), 'rb' )
    
    response = RestClient.post( "0.0.0.0:5000/ontology_generate",
      {
        :file => workflow        
      }
    )
    @explanation = JSON.parse(response)
  end
  
  def wf_update
    @tree = Tree.first
    workflow = File.new( Rails.root.join('app', 'views', 'trees', "workflow_plan_1.json"), 'rb' )
    
    response = RestClient.post( "0.0.0.0:5000/traversing_ontology_generate",
      {
        :file => workflow        
      }.merge(params.permit!)
    )
    @explanation = JSON.parse(response)
    respond_to do |format|
      format.js 
    end
  end
  
  def metadata
    if @tree.studies.nil?
      begin
        otts = JSON.parse(@tree.tree)["newick"].scan(/ott\d+/)
      rescue
        respond_to do |format|
          format.js { 
            render template: "metadata_fail.js.erb" 
            return
          }
        end
      end
      ids = otts.map {|o| o.match(/\d+/)[0]}
      response = RestClient.get( Rails.configuration.x.sv_OToL_supported_studies + ids.join('|'))
      @tree.update_attributes(studies: response)
    end

    @tree_metadata = JSON.parse(@tree.studies)
    respond_to do |format|
      format.js 
    end
  end
  
  def download_studies
    return if params["p"].nil?
    @bib = params["p"].keys().map do |doi|
      begin
        b = RestClient.get( doi, {accept: "text/bibliography; style=bibtex"}).body
        b.gsub!("}, ", "},\n").gsub!("=", " = ").strip!()
        b
      rescue
        ""
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
  def download_tree_info
    send_data @tree.info.to_json, :filename => @tree.name + "_info.json"
  end
  
  private 
  
  def find_tree
    @tree = Tree.select{ |l| l.id == params[:id].to_i }.first
    # @tree = current_or_guest_user.trees.select{ |l| l.id == params[:id].to_i }.first
  end
  
  def tree_params
    params.require(:tree).permit(:branch_length, :image, :list_from_service, 
                                 :name, :action_sequence)
  end
end

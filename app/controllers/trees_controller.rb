class TreesController < ApplicationController
  include TreesHelper
  include ListsHelper
  
  before_action :find_tree, only: [:destroy, :edit, :update, :show, :download]
  
  def index
  end

  def show
    if cookies[:view_hint].nil?
      cookies[:view_hint] = { :value => "true", :expires => 1.month.from_now }
    end
    
    if @tree.list_from_service
      @list = get_a_list_from_service(@tree.list_id)
      @list_name = @list["list"]["list_title"]
      @link_to_list = list_path(@tree.list_id, from_service: true)
    else
      @list = List.find(@tree.list_id)
      @list_name = @list.name
      if @list.nil?
        @link_to_list = nil
      else
        @link_to_list = list_path(@list)
      end
    end    
  end

  def create
    @tree = current_or_guest_user.trees.build(tree_params.merge(list_id: params[:list_id]))
    species = params[:tree][:species]
    @tree.species = species.to_json
    chosen_species = species.select { |x| species[x] == "1" }.keys
    extracted_response = Req.post( Rails.configuration.x.sv_OToL_wrapper_Tree,
                                     {"taxa": chosen_species}.to_json,
                                     :content_type => :json,
                                     :accept => :json )
    @tree.tree = extracted_response.to_json
    if @tree.save
      redirect_to @tree
    else
      redirect_to root_path
    end
  end

  def edit
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
        send_data sanitize_newick(@tree), :filename => @tree.name + "_newick.txt"
      end
    end
  end
  
  private 
  
  def find_tree
    @tree = current_or_guest_user.trees.select{ |l| l.id == params[:id].to_i }.first
  end
  
  def tree_params
    params.require(:tree).permit(:branch_length, :image, :list_from_service, 
                                 :name, :action_sequence)
  end
end

class TreesController < ApplicationController
  before_action :find_tree, only: [:destroy, :edit, :update, :show]
  
  def index
  end

  def show
    if @tree.list_from_service
      @link_to_list = list_path(@tree.list_id, from_service: true)
    else
      @list = List.find(@tree.list_id)
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
    @tree.species = species.to_s
    chosen_species = species.select { |x| species[x] == "1" }.keys
    extracted_response = Req.post( Rails.configuration.x.sv_OToL_wrapper_Tree,
                                     {"taxa": chosen_species}.to_json,
                                     :content_type => :json,
                                     :accept => :json )
    @tree.tree = extracted_response
    if @tree.save
      redirect_to @tree
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
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

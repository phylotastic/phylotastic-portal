class WatchRelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @tree = Tree.find(params["tree_id"])
    current_user.watch(@tree)
    respond_to do |format|
      format.html { redirect_to @tree }
      format.js
    end
  end
  
  def destroy
    @tree = WatchRelationship.find(params[:id]).tree
    current_user.unwatch(@tree)
    respond_to do |format|
      format.html { redirect_to @tree }
      format.js
    end
  end
  
  def add_public_gallery
    @tree = Tree.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def gallery
    @trees = current_user.watched_trees
  end
  
end

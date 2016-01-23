class TreesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @tree = current_user.trees.build
  end
  
  def create
  end
end

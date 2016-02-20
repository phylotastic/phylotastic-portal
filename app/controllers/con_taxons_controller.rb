class ConTaxonsController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end

  def create
    binding.pry
    @tree = current_user.trees.build(tree_params)
    if @tree.save
      flash[:success] = "Tree created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end
  
  private
    def tree_params
      params.require(:con_taxon).permit(:name)
    end
end

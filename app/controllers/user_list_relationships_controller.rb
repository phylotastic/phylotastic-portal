class UserListRelationshipsController < ApplicationController
  
  def destroy
    list = UserListRelationship.find(params[:id]).uploaded_list
    trees = current_user.trees_from_public_list(list)
    trees.each do |t|
      t.destroy
    end
    current_user.unsubcribe(list)
    redirect_to trees_path
  end

end

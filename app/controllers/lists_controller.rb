class ListsController < ApplicationController
  def edit
  end

  def update
  end

  def index
    @my_lists = current_or_guest_user.lists
    @my_lists.sort_by!{ |m| m.name.downcase }

    res = Req.get(Rails.configuration.x.public_lists_sv.url)
    @public_lists = JSON.parse(res)["lists"] rescue []
    @public_lists.sort_by! {|m| m["list_title"].downcase }
    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
  end
end

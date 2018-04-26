class ListsController < ApplicationController
  include ListsHelper
  
  def show
    if params[:from_service]
      @list = get_a_list_from_service(params[:id])
      if @list.empty?
        respond_to do |format|
          format.js { 
            render template: "lists/show_failed.js.erb" 
            return
          }
        end
      end
      
      if @list["list"]["is_list_public"]
        # @uploaded_list = UploadedList.find_or_create(@list)
        # @ra = @uploaded_list.raw_extraction
        # @uploaded_list.update_attributes(name: @list["list"]["list_title"])
        
        @list_name = @list["list"]["list_title"]
        respond_to do |format|
          format.js
        end
      else
        respond_to do |format|
          format.js { 
            render template: "lists/redirect.js.erb" 
            return
          }
        end
      end

    else
      @list = current_or_guest_user.lists.select{ |l| l.id == params[:id].to_i}
      if @list.empty?
        respond_to do |format|
          format.js { 
            render template: "lists/redirect.js.erb" 
            return
          }
        end
      end
      @list = @list.first
      @list_name = @list.name
      respond_to do |format|
        format.js
      end
    end
  end
  
  def edit
  end

  def update
  end

  def index
    @my_lists = current_or_guest_user.lists
    @my_lists.sort_by!{ |m| m.name.downcase }

    @public_lists = get_lists_from_service()
    @public_lists.sort_by! {|m| m["list_title"].downcase }
    respond_to do |format|
      # format.js
      format.html
    end
  end

  def destroy
  end
end

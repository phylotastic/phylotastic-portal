class ListsController < ApplicationController
  before_action :find_list, only: [:destroy, :edit, :update]
  
  
  include ListsHelper
  
  def show
    @from_service = false
    @is_private   = false
    
    if params[:from_service]
      @from_service = true
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
      @is_private = true
      @list = current_or_guest_user.lists.select{ |l| l.id == params[:id].to_i}
      
      if @list.empty?
        respond_to do |format|
          format.js { 
            render template: "lists/redirect.js.erb" 
            return
          }
          format.html {
            redirect_to root_path
            return
          }
        end
      end
      @list = @list.first
      @list_name = @list.name
      
      @tree = current_or_guest_user.trees.build
      @names = @list.species_names
      @unmatched_names = @list.unmatched_names
      
      respond_to do |format|
        format.js
        format.html {
          @my_lists = current_or_guest_user.lists
          @my_lists.sort_by!{ |m| m.name.downcase }

          @public_lists = get_lists_from_service()
          @public_lists.sort_by! {|m| m["list_title"].downcase }
        }
      end
    end
  end
  
  def edit
  end

  def update
    @list.update_attributes(list_params)
    flash[:success] = "List is updated!"
    redirect_to lists_path
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
    unless @list.nil?
      @list.resource.destroy
      flash[:success] = @list.name + " is removed!"
    end
    redirect_to lists_path
  end
  
  private
  
    def find_list
      @list = current_or_guest_user.lists.select{ |l| l.id == params[:id].to_i }.first
    end
  
    def list_params
      params.require(:list).permit(:name, :description)
    end
  
end

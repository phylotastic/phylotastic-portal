class ListsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:download]
  
  before_action :find_list, only: [:destroy, :edit, :update, :resolve_names, :download]
  
  
  include ListsHelper
  
  def show
    response.set_header("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
        
    @from_service = false
    @is_private   = false
    @tree = current_or_guest_user.trees.build
    
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
        @names = @list["list"]["list_species"]
        respond_to do |format|
          format.js
          format.html {
            @my_lists = current_or_guest_user.lists
            @my_lists.sort_by!{ |m| m.name.downcase }

            @public_lists = get_lists_from_service()
            @public_lists.sort_by! {|m| m["list_title"].downcase }
          }
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
    response.set_header("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
    
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
      @list.destroy_trees
      @list.resource.destroy
      flash[:success] = @list.name + " is removed!"
    end
    redirect_to lists_path
  end
  
  def resolve_names
    @replace = params[:replace]
    res = Req.get(Rails.configuration.x.sv_OToL_TNRS_wrapper_get + @replace)
    if res["total_names"] == 0
      respond_to do |format|
        format.js { 
          render template: "lists/unresolve.js.erb" 
          return
        }
      end
    else
      extracted = @list.extracted_names
      extracted.each_with_index do |n, i| 
        if n == params[:unresolve]
          extracted[i] = params[:replace]
        end
      end
      
      resolved = @list.species_names.map {|l| l["matched_results"][0]["matched_name"]}
      unless resolved.include? res["resolvedNames"][0]["matched_results"][0]["matched_name"]
        updated = @list.species_names << res["resolvedNames"][0]
      else
        updated = @list.species_names
      end
      @list.update_attributes(
        resolved: {"resolvedNames": updated}.to_json, 
        extracted: {"scientificNames": extracted}.to_json
      )
      
      @names = updated
      @tree = current_or_guest_user.trees.build
      
      respond_to do |format|
        format.js 
      end
    end
    # redirect_to lists_path
  end
  
  def download
    send_data params["species"].gsub(",", "\n"),
        :filename => "list.txt",
        :type => "text/plain",
        disposition: 'attachment'
  end

  private
  
    def find_list
      @list = current_or_guest_user.lists.select{ |l| l.id == params[:id].to_i }.first
    end
  
    def list_params
      params.require(:list).permit(:name, :description)
    end
  
end

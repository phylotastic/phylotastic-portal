class RawExtractionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :download_selected_species
  
  include UploadedListsHelper
  include Tubesock::Hijack
  
  def index
    if user_signed_in?
      if !cookies[:temp_id].nil?
        cookies.delete :temp_id
      end
      
      # my_failed_lists  = current_user.failed_lists
#       my_failed_lists = [] if my_failed_lists.nil?
#       my_failed_lists.map! do |l|
#         name = l.name.nil? ? l.file.original_filename : l.name
#         {id: l.id, name: name, class: "FailedList"}
#       end
#
#       # @my_subcribing_lists = current_user.subcribing_lists
#       # @my_subcribing_lists = [] if @my_subcribing_lists.nil?
#
#       my_private_lists = get_private_lists["lists"] rescue []
#       my_private_lists = [] if my_private_lists.nil?
#       my_private_lists.map! do |l|
#         {id: l["list_id"], name: l["list_title"], class: "UploadedList"}
#       end
#
#       cfiles  = current_user.con_files.map do |f|
#         {id: f.id, name: f.name, class: "ConFile"}
#       end
#       ofiles  = current_user.onpl_files.map do |f|
#         {id: f.id, name: f.name, class: "OnplFile"}
#       end
#       clinks  = current_user.con_links.map do |f|
#         {id: f.id, name: f.name, class: "ConLink"}
#       end
#       ctaxons = current_user.con_taxons.map do |f|
#         {id: f.id, name: f.name, class: "ConTaxon"}
#       end
#
      user = current_user
    else
      if cookies[:temp_id].nil?
        cookies[:temp_id] = { value: ('a'..'z').to_a.shuffle[0,20].join, expires: 1.day.from_now }
      end
      
      user = User.find_by_email(APP_CONFIG['anonymous'])
      
      # my_private_lists = []
#
#       my_failed_lists  = user.failed_lists.select do |l|
#         if !l.raw_extraction.nil?
#           l.created_at > Time.now - 1.day && l.raw_extraction.temp_id == cookies[:temp_id]
#         end
#       end
#       if my_failed_lists.nil?
#         my_failed_lists = []
#       else
#         my_failed_lists.map! do |l|
#           name = l.name.nil? ? l.file.original_filename : l.name
#           {id: l.id, name: name, class: "FailedList"}
#         end
#       end
#
#       cfiles  = user.con_files.select do |l|
#         if !l.raw_extraction.nil?
#           l.created_at > Time.now - 1.day && l.raw_extraction.temp_id == cookies[:temp_id]
#         end
#       end
#       cfiles.map! do |f|
#         {id: f.id, name: f.name, class: "ConFile"}
#       end
#
#       ofiles  = user.onpl_files.select do |l|
#         if !l.raw_extraction.nil?
#           l.created_at > Time.now - 1.day && l.raw_extraction.temp_id == cookies[:temp_id]
#         end
#       end
#       ofiles.map! do |f|
#         {id: f.id, name: f.name, class: "OnplFile"}
#       end
#
#       clinks  = user.con_links.select do |l|
#         if !l.raw_extraction.nil?
#           l.created_at > Time.now - 1.day && l.raw_extraction.temp_id == cookies[:temp_id]
#         end
#       end
#       clinks.map! do |f|
#         {id: f.id, name: f.name, class: "ConLink"}
#       end
#
#       ctaxons = user.con_taxons.select do |l|
#         if !l.raw_extraction.nil?
#           l.created_at > Time.now - 1.day && l.raw_extraction.temp_id == cookies[:temp_id]
#         end
#       end
#       ctaxons.map! do |f|
#         {id: f.id, name: f.name, class: "ConTaxon"}
#       end
      
    end
    @my_lists = user.raw_extractions
    
    # @my_lists = my_private_lists << my_failed_lists << cfiles << ofiles << clinks << ctaxons
    @my_lists.to_a.sort_by!{ |m| m.name.downcase }

    res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
    @public_lists = JSON.parse(res)["lists"] rescue []
    @public_lists.sort_by! {|m| m["list_title"].downcase }
  end
  
  def checking_status
    source = RawExtraction.find(params[:id])
    job_id = params[:jid]
    
    hijack do |tubesock|
      while Sidekiq::Status::queued? job_id
        sleep 1
        data = {status: "queue", pct: 0}.to_json
        tubesock.send_data data
      end
      while Sidekiq::Status::working? job_id
        sleep 1        
        pct = Sidekiq::Status::pct_complete job_id
        data = {status: "working", pct: pct}.to_json
        tubesock.send_data data
      end
    
      if Sidekiq::Status::complete? job_id
        data = {status: "complete", pct: 100}.to_json
        tubesock.send_data data
      end
    
      if Sidekiq::Status::failed? job_id
        data = {status: "failed", pct: 0}.to_json
        tubesock.send_data data
      end
    
      if Sidekiq::Status::interrupted? job_id
        pct = Sidekiq::Status::pct_complete job_id
        data = {status: "interrupted", pct: pct}.to_json
        tubesock.send_data data
      end
    end
  end
  
  def show
    @ra = RawExtraction.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def download_selected_species
    send_data params["species"].gsub(",", "\n"),
        :filename => params["name"] + ".txt",
        :type => "text/plain",
        disposition: 'attachment'
  end
  
end

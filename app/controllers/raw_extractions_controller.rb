class RawExtractionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :download_selected_species
  
  include UploadedListsHelper
  include Tubesock::Hijack
  
  def index
    if user_signed_in?
      my_failed_lists  = current_user.failed_lists
      my_failed_lists = [] if my_failed_lists.nil?
      @my_failed_lists = my_failed_lists.map do |l|
        name = l.name.nil? ? l.file.original_filename : l.name
        {id: l.id, name: name, class: "FailedList"}
      end
      
      # @my_subcribing_lists = current_user.subcribing_lists
      # @my_subcribing_lists = [] if @my_subcribing_lists.nil?
    
      my_lists = get_private_lists["lists"] rescue []
      my_lists = [] if my_lists.nil?
      @my_lists = my_lists.map do |l|
        {id: l["list_id"], name: l["list_title"], class: "UploadedList"}
      end
      
      @cfiles  = current_user.con_files.map do |f|
        {id: f.id, name: f.name, class: "ConFile"}
      end
      @ofiles  = current_user.onpl_files.map do |f|
        {id: f.id, name: f.name, class: "OnplFile"}
      end
      @clinks  = current_user.con_links.map do |f|
        {id: f.id, name: f.name, class: "ConLink"}
      end
      @ctaxons = current_user.con_taxons.map do |f|
        {id: f.id, name: f.name, class: "ConTaxon"}
      end
    end
    res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
    @public_lists = JSON.parse(res)["lists"] rescue []
    @public_lists.sort_by! {|m| m["list_title"].downcase }
  end
  
  def checking_status
    case params[:type]
    when "cl"
      source = ConLink.find(params[:id])
    when "cf"
      source = ConFile.find(params[:id])
    when "ct"
      source = ConTaxon.find(params[:id])
    when "of"
      source = OnplFile.find(params[:id])
    when "ul"
      source = UploadedList.find(params[:id])
    end
    
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
        if params[:type] == "ul"
          source = UploadedList.find(params[:id])
          if source.status
            data = {status: "complete", pct: 100, type: "ul", id: source.lid}.to_json
          else
            data = {status: "complete", pct: 100, type: "fl", id: source.id}.to_json
          end
        end
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
  
  def download_selected_species
    send_data params["species"].gsub(",", "\n"),
        :filename => "species.txt",
        :type => "text/plain",
        disposition: 'attachment'
  end
  
end

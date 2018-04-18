class RawExtractionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:download_selected_species, :taxon_matching_report]
  
  include UploadedListsHelper
  include Tubesock::Hijack
  
  def taxon_matching_report
    ra = RawExtraction.find(params[:raw_extraction_id])
    @resolved_names = JSON.parse(ra.species)["resolvedNames"] rescue []
    respond_to do |format|
      format.pdf do
        render pdf: "taxon_matching_report",
               template: "raw_extractions/taxon_matching_report.pdf.erb"
      end
      format.csv do
        render csv: "taxon_matching_report",
               template: "raw_extractions/taxon_matching_report.csv.erb"
      end
    end
  end
      
  def index
    if @user == User.anonymous
      @my_lists = @user.raw_extractions.select do |r|
        r.created_at > Time.now - 1.day && r.temp_id == cookies[:temp_id]
      end
    else
      @my_lists = @user.raw_extractions
    end
    
    @my_lists.to_a.sort_by!{ |m| m.name.downcase }

    res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
    @public_lists = JSON.parse(res)["lists"] rescue []
    @public_lists.sort_by! {|m| m["list_title"].downcase }
    respond_to do |format|
      format.js
      format.html
    end
        
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

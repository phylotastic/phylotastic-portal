class RawExtractionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :download_selected_species
  before_action :authenticate_user!
  
  include UploadedListsHelper
  
  def index
    @my_failed_lists  = current_user.failed_lists
    @my_failed_lists = [] if @my_failed_lists.nil?

    @my_subcribing_lists = current_user.subcribing_lists
    @my_subcribing_lists = [] if @my_subcribing_lists.nil?
    
    @my_lists = get_private_lists["lists"] rescue []
    @my_lists = [] if @my_lists.nil?
    @cfiles  = current_user.con_files
    @ofiles  = current_user.onpl_files
    @clinks  = current_user.con_links
    @ctaxons = current_user.con_taxons

    res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
    @public_lists = JSON.parse(res)["lists"] rescue []
  end
  
  def download_selected_species
    send_data params["species"].gsub(",", "\n"),
        :filename => "species.txt",
        :type => "text/plain",
        disposition: 'attachment'
  end
  
end

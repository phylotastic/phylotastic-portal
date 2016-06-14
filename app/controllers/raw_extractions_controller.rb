class RawExtractionsController < ApplicationController
  before_action :authenticate_user!
  
  include UploadedListsHelper
  
  def new_from_file_and_web
    @con_link = ConLink.new
    @con_file = ConFile.new
  end
  
  def new_from_pre_built_examples
    @uploaded_list = UploadedList.new
    current_user.refresh_token_if_expired
    
    res = Req.get(APP_CONFIG["sv_get_private_lists"]["url"] + "?user_id=" + current_user.email + "&access_token=" + current_user.access_token)
    @my_lists = JSON.parse(res)["lists"] rescue []
    
    res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
    @public_lists = JSON.parse(res)["lists"] rescue []
  end
  
  def new_from_taxon
    @con_taxon = ConTaxon.new
    @selection_taxon = SelectionTaxon.new
    @subset_taxon = SubsetTaxon.new
  end
  
  def index
    @my_failed_lists  = current_user.failed_lists
    @my_failed_lists = [] if @my_failed_lists.nil?
    
    @my_subcribing_lists = current_user.subcribing_lists
    @my_subcribing_lists = [] if @my_subcribing_lists.nil?
    
    @my_lists         = get_private_lists["lists"] rescue []
    @my_lists = [] if @my_lists.nil?
    
    @cfiles           = current_user.con_files
    @clinks           = current_user.con_links
    @ctaxons          = current_user.con_taxons
    @subset_taxons    = current_user.subset_taxons
    @selection_taxons = current_user.selection_taxons
    
    res = Req.get(APP_CONFIG["sv_get_public_lists"]["url"])
    @public_lists = JSON.parse(res)["lists"] rescue []
  end
end

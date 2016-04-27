class RawExtractionsController < ApplicationController
  before_action :authenticate_user!
  
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
  
end

class RawExtractionsController < ApplicationController
  before_action :authenticate_user!
  
  def new_from_file_and_web
    @con_link = ConLink.new
    @con_file = ConFile.new
  end
  
  def new_from_pre_built_examples
    @uploaded_list = UploadedList.new
    res = Req.get(APP_CONFIG["sv_getuserlist"]["url"] + current_user.email + "&access_token=" + "")
    @my_lists = res ? JSON.parse(res)["lists"] : {}
    binding.pry
    
    res = Req.get(APP_CONFIG["sv_getpubliclists"]["url"])
    @public_lists = res ? JSON.parse(res)["public_lists"] : {}
  end
  
  def new_from_taxon
    @con_taxon = ConTaxon.new
    @selection_taxon = SelectionTaxon.new
    @subset_taxon = SubsetTaxon.new
  end
  
end

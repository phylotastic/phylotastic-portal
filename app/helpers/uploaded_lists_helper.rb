module UploadedListsHelper
  
  def get_a_list(list_id)
    res = Req.get(APP_CONFIG["sv_getlist"]["url"] + list_id.to_s)
    return res ? JSON.parse(res)["list"] : []
  end
  
end

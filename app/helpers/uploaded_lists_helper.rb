module UploadedListsHelper
  
  def get_a_list(list_id)
    # public_lists = UploadedList.find_by_public(true)
    current_user.refresh_token_if_expired
    res = Req.get(APP_CONFIG["sv_get_a_list"]["url"] + "?verbose=true&user_id=" + current_user.email + "&list_id=" + list_id.to_s + "&access_token=" + current_user.access_token)
    # res = Req.get(APP_CONFIG["sv_get_a_list"]["url"] + "?list_id=" + list_id)
    return JSON.parse(res)
  end
  
  def get_private_lists
    current_user.refresh_token_if_expired
    res = Req.get(APP_CONFIG["sv_get_private_lists"]["url"] + "?user_id=" + current_user.email + "&access_token=" + current_user.access_token)
    return JSON.parse(res)
  end
  
  def remove_private_list(list_id)
    current_user.refresh_token_if_expired
    res = Req.get(APP_CONFIG["sv_remove_private_list"]["url"] + "?user_id=" + current_user.email + "&list_id=" + list_id.to_s + "&access_token=" + current_user.access_token)
    return JSON.parse(res)
  end
end

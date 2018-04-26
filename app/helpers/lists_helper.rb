module ListsHelper

  def get_a_list_from_service(list_id)
    Req.get(Rails.configuration.x.public_lists_sv.url + "?verbose=true" + "&list_id=" + list_id.to_s)
  end
  
  def get_lists_from_service
    res = Req.get(Rails.configuration.x.public_lists_sv.url)
    res["lists"].nil? ? [] : res["lists"]
  end
  
end

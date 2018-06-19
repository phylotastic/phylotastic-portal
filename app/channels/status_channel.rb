class StatusChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "status_channel_#{params[:tree_id]}" if /[a-zA-Z]/.match(params[:tree_id]).nil?
  end
  
end
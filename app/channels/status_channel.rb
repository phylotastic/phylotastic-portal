class StatusChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "status_channel_#{params[:tree_id]}"
  end
  
end
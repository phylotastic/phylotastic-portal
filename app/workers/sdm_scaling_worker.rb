class SdmScalingWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include TreesHelper

  def perform(id)
    tree = Tree.find(id)
    sleep 1
    scaled_response = Req.post( Rails.configuration.x.sv_Datelife_scale_tree,
                                {"newick": sanitize_newick(tree.unscaled), method: "sdm"}.to_json,
                                {
                                  :content_type => :json, 
                                  :accept => :json
                                },
                                true )
    
    tree.update_attributes(scaled_sdm: scaled_response.to_json)
    
    ActionCable.server.broadcast "status_channel_#{tree.id}", 
    {
      method: "scaled_sdm",
      response: scaled_response
    }.to_json
    
  end
end

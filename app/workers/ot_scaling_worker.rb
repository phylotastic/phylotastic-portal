class OtScalingWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include TreesHelper
  
  def perform(id)
    tree = Tree.find(id)

    scaled_response = Req.post( Rails.configuration.x.sv_OToL_scale_tree,
                                {"newick": sanitize_newick(tree.unscaled)}.to_json,
                                {
                                  :content_type => :json, 
                                  :accept => :json
                                },
                                true )
    
    tree.update_attributes(scaled_ot: scaled_response.to_json)
    
    ActionCable.server.broadcast "status_channel_#{tree.id}", 
    {
      method: "scaled_ot",
      response: scaled_response
    }.to_json
    
  end
end

class CommonNameWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include TreesHelper

  def perform(id)
    tree = Tree.find(id)

    mapping_response = Req.post( Rails.configuration.x.sv_tc,
                                {"newick_tree": sanitize_newick(tree.unscaled)}.to_json,
                                {
                                  :content_type => :json, 
                                  :accept => :json
                                },
                                true )
    
    tree.update_attributes(common_name_mapping: mapping_response.to_json)
    
    ActionCable.server.broadcast "status_channel_#{tree.id}", 
    {
      method: "common_names",
      response: mapping_response
    }.to_json
    
  end
end

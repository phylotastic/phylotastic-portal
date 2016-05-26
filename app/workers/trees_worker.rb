class TreesWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(tree_id)
    tree = Tree.find_by_id(tree_id)
    
    logger.info "Found tree ##{tree_id}!"
    puts tree.id
    
    resolved = JSON.parse(tree.raw_extraction.species) rescue []
    if(resolved["resolvedNames"].length == 0)
      tree.update_attributes( status: "unsuccessfully-constructed", 
                              bg_job: "-1",
                              representation: nil )
      return 
    end
    
    chosen_species = JSON.parse(tree.chosen_species).select {|k,v| v == "1"}.map {|k,v| k }
    resolved["resolvedNames"] = resolved["resolvedNames"].select do |r|
      chosen_species.include? r["matched_name"]
    end

    sleep 3
    
    begin
      constructed_response = Req.post( APP_CONFIG["sv_get_tree"]["url"],
                                       resolved.to_json,
                                       :content_type => :json, 
                                       :accept => :json )
    rescue => e
      puts e
      logger.info "Call service error"
    end
    
    if !constructed_response
      tree.update_attributes( status: "unsuccessfully-constructed", 
                              bg_job: "-1",
                              representation: nil )
    elsif JSON.parse(constructed_response)["message"] == "Success" 
      tree.update_attributes( status: "completed", 
                              bg_job: "-1",
                              representation: constructed_response )
    else
      tree.update_attributes( status: "unsuccessfully-constructed", 
                              bg_job: "-1",
                              representation: constructed_response )
    end
  end
end
class TreesWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(tree_id)
    # snippet = Snippet.find(snippet_id)
    # uri = URI.parse("http://pygments.appspot.com/")
    # request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
    # snippet.update_attribute(:highlighted_code, request.body)
    tree = Tree.find_by_id(tree_id)
    if tree.nil?
      logger.info "Oops! Tree not found"
    else
      logger.info "Found tree ##{tree_id}!"
      puts tree.id
    end

    tree.update_attributes(status: "constructing")
    
    resolved = JSON.parse(tree.raw_extraction.species)
    chosen_species = JSON.parse(tree.chosen_species).select {|k,v| v == "1"}.map {|k,v| k }
    resolved["resolvedNames"].each do |r|
      if !chosen_species.include? r["matched_name"]
        resolved["resolvedNames"].delete r
      end
    end
    
    
    begin
      constructed_response = RestClient.post( APP_CONFIG["sv_gettree"]["url"],
                                              resolved.to_json,
                                              :content_type => :json, 
                                              :accept => :json)
    rescue => e
      puts e
      logger.info "Call service error"
    end
    
    if constructed_response.nil?
      tree.update_attributes(status: "unsuccessfully-constructed", bg_job: "-1")
    else
      tree.update_attributes( status: "completed", 
                              bg_job: "-1",
                              representation: constructed_response )
    end
  end
end
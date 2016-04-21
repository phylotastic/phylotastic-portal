class ExtractionsWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(source_id, source_type, current_user_id)
    puts source_id
    puts source_type
    # puts self.jid
    
    owner = User.find_by_id(current_user_id)
    
    # call extracting service based on types of source
    case source_type
    when "ConLink"
      extracted_response = Req.get(APP_CONFIG['sv_findnames']['url'] + ConLink.find_by_id(source_id).uri)
    when "ConFile"
      file_url = ConFile.find_by_id(source_id).document.url
      file_url.slice!(/[?]\d*\z/)
      file_url = APP_CONFIG['domain'] + file_url
      extracted_response = Req.get(APP_CONFIG['sv_findnames']['url'] + file_url) 
    end
    
    # raw extraction
    extraction = source_type.constantize.find_by_id(source_id).create_raw_extraction(species: extracted_response)

    # retrieve tree corresponding to the above raw extraction
    tries = 3
    begin
      tree = Tree.find_by_bg_job(self.jid)
      raise "Cannot find tree executed by background job #{self.jid}." if tree.nil?
    rescue Exception => e  
      puts e.message
      puts e.backtrace.inspect
      tries -= 1
      sleep 1
      if tries > 0
        retry
      else
        logger.info "Oh Noes!"
        tree = owner.trees.create(bg_job: self.jid)
      end
    end

    # if extracting service has problems, it is time to terminate
    if extracted_response.nil?
      tree.update_attributes( raw_extraction_id: extraction.id, 
                              bg_job: "-1", 
                              status: "unsucessfully-extracted" )
      return
      
    # if there are no names in resource
    elsif JSON.parse(extracted_response)["scientificNames"].empty?
      tree.update_attributes( raw_extraction_id: extraction.id, 
                              bg_job: "-1", 
                              status: "no-names" )
      return
    end
    
    # save extracted_response in raw extraction
    extraction.update_attributes(species: extracted_response)

    # update status "extracted" to tree
    tree.update_attributes( raw_extraction_id: extraction.id, 
                            status: "extracted" )
    
    # call to resolution names service
    resolved_response = Req.post( APP_CONFIG["sv_resolvenames"]["url"],
                                  extracted_response,
                                  :content_type => :json )
    
    # update state of tree
    if !resolved_response
      tree.update_attributes(bg_job: "-1", status: "unsucessfully-resolved")
    else
      extraction.update_attributes(species: resolved_response)
      tree.update_attributes(bg_job: "-1", status: "resolved")
    end
  end
end
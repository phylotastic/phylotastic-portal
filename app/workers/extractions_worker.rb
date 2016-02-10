class ExtractionsWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(source_id, source_type, current_user_id)
    # snippet = Snippet.find(snippet_id)
    # uri = URI.parse("http://pygments.appspot.com/")
    # request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
    # snippet.update_attribute(:highlighted_code, request.body)
    puts source_id
    puts source_type
    puts self.jid
    
    total 100 # by default
    at 5, "Almost done"
    sleep 3
    # a way to associate data with your job
    store vino: 'veritas'
    at 20, "Done in a sec"
    # a way of retrieving said data
    # remember that retrieved data is always is String|nil
    vino = retrieve :vino
    
    
    
    
    
    
    
    
    
    
    owner = User.find_by_id(current_user_id)
    
    # TODO: query source
    # TODO: call services to extract

    # create RawExtraction, TODO: change species with data got from service
    extraction = source_type.constantize.find_by_id(source_id).raw_extraction.create(species: "123")

    tries = 3
    begin
      tree = Tree.find_by_bg_job(self.jid)
      raise "Cannot find tree executed by background job #{self.jid}." if tree.nil?
      logger.info "Success!"
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
    # TODO: remove sleep
    sleep 40
    tree.update_attributes(raw_extraction_id: extraction.id, bg_job: "-1", status: "extracted")
  end
end
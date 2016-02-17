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
      logger.info "Success!"
      puts tree.id
    end

    tree.update_attributes(status: "resoluting names")
    # TODO: call services
        
    total 100 # by default
    at 5, "Almost done"
    # a way to associate data with your job
    store vino: 'veritas'
    at 20, "Done in a sec"
    # a way of retrieving said data
    # remember that retrieved data is always is String|nil
    vino = retrieve :vino
    
    tree.update_attributes(status: "completed", bg_job: "-1")
  end
end
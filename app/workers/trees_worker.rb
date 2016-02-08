class TreesWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(source_id, source_type)
    # snippet = Snippet.find(snippet_id)
    # uri = URI.parse("http://pygments.appspot.com/")
    # request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
    # snippet.update_attribute(:highlighted_code, request.body)
    puts source_id
    puts source_type
    
    total 100 # by default
    at 5, "Almost done"
    sleep 3
    # a way to associate data with your job
    store vino: 'veritas'
    at 20, "Done in a sec"
    # a way of retrieving said data
    # remember that retrieved data is always is String|nil
    vino = retrieve :vino
  end
end
class TreesWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  
  def perform(source_id, source_type)
    # snippet = Snippet.find(snippet_id)
    # uri = URI.parse("http://pygments.appspot.com/")
    # request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
    # snippet.update_attribute(:highlighted_code, request.body)
    puts source_id
    puts source_type
  end
end
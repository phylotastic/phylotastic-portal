require 'zip'

class ListProcessingWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(user_name, ul_id)
    f_path = UploadedList.find(ul_id).file.path
    Zip::File.open(f_path) do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        # Extract to file/directory/symlink
        puts "Extracting #{entry.name}"
        el = UploadedList.extraction_location(f_path, entry.name)
        entry.extract(el)
      end

      begin
        UploadedList.process(user_name, ul_id)
      rescue Exception => e
        puts e
        # puts e.backtrace
      end
      
      # Find specific entry
      # entry = zip_file.glob('*.csv').first
      # puts entry.get_input_stream.read
    end
  end
  
end
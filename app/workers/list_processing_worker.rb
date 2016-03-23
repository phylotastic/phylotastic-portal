require 'zip'

class ListProcessingWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false
  include Sidekiq::Status::Worker
  
  def perform(f_path)
    Zip::File.open(f_path) do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        # Extract to file/directory/symlink
        puts "Extracting #{entry.name}"
        el = UploadedList.extraction_location(f_path, entry.name)
        entry.extract(el)

        begin
          UploadedList.process(File.open(el))
        rescue Exception => e
          puts e
          puts e.backtrace
        end
      end

      # Find specific entry
      # entry = zip_file.glob('*.csv').first
      # puts entry.get_input_stream.read
    end
  end
  
end
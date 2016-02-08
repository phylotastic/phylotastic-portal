class TrackersController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      # Listen on its own thread
      redis_thread = Thread.new do
        # Needs its own redis connection to pub
        # and sub at the same time
        Redis.new.subscribe "chat" do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        job_id = MyJob.perform_async(*args)
        data = Sidekiq::Status::get_all job_id
        data # => {status: 'complete', update_time: 1360006573, vino: 'veritas'}
        Sidekiq::Status::get     job_id, :vino #=> 'veritas'
        Sidekiq::Status::at      job_id #=> 5
        Sidekiq::Status::total   job_id #=> 100
        Sidekiq::Status::message job_id #=> "Almost done"
        Sidekiq::Status::pct_complete job_id #=> 5
        
        # pub the message when we get one
        # note: this echoes through the sub above
        Redis.new.publish "chat", m
      end
    
      tubesock.onclose do
        # stop listening when client leaves
        redis_thread.kill
      end
    end
  end
end


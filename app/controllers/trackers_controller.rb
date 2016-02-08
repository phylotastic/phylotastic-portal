class TrackersController < ApplicationController
  include Tubesock::Hijack

  def track
    hijack do |tubesock|
      tubesock.onopen do
        tubesock.send_data "Hello, friend"
      end

      tubesock.onmessage do |data|
        binding.pry
        job_id = params[:job_id]
        data = Sidekiq::Status::get_all job_id
        data # => {status: 'complete', update_time: 1360006573, vino: 'veritas'}
        Sidekiq::Status::get     job_id, :vino #=> 'veritas'
        Sidekiq::Status::at      job_id #=> 5
        Sidekiq::Status::total   job_id #=> 100
        Sidekiq::Status::message job_id #=> "Almost done"
        Sidekiq::Status::pct_complete job_id #=> 5
        
        tubesock.send_data "You said: #{data}"
      end
    end
  end
end



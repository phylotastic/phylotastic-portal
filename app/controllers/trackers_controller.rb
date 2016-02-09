class TrackersController < ApplicationController
  include Tubesock::Hijack

  def track
    hijack do |tubesock|
      tubesock.onopen do
        # tubesock.send_data "Hello, friend"
      end

      tubesock.onmessage do |tree_id|
        sleep rand(3)
        tree = current_user.trees.find_by_id(tree_id.to_i)
        if tree.nil?
          tubesock.send_data "#{tree_id} not found"
        end
        if tree.bg_job != "-1" 
          data = Sidekiq::Status::get_all tree.bg_job
          data # => {status: 'complete', update_time: 1360006573, vino: 'veritas'}
          # Sidekiq::Status::get     job_id, :vino #=> 'veritas'
          # Sidekiq::Status::at      job_id #=> 5
          # Sidekiq::Status::total   job_id #=> 100
          # Sidekiq::Status::message job_id #=> "Almost done"
          # Sidekiq::Status::pct_complete job_id #=> 5
        
          tubesock.send_data "#{data.merge!(tree_id: tree_id).to_json}"
        else
          data = {status: tree.status, tree_id: tree_id}.to_json
          tubesock.send_data "#{data}"
        end
      end
    end
  end
end



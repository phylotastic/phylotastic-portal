class TrackersController < ApplicationController
  before_action :authenticate_user!
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
          # Sidekiq::Status::get     job_id, :vino #=> 'veritas'
          # Sidekiq::Status::at      job_id #=> 5
          # Sidekiq::Status::total   job_id #=> 100
          # Sidekiq::Status::message job_id #=> "Almost done"
          # Sidekiq::Status::pct_complete job_id #=> 5
          
          while Sidekiq::Status::working?(tree.bg_job) || Sidekiq::Status::queued?(tree.bg_job)
            sleep 10
            puts "sleeping"
          end
          bg_job_status = Sidekiq::Status::get_all tree.bg_job
          if bg_job_status.nil?
            data = {status: "error", tree_id: tree_id}.to_json
            logger.info "Job expired"
          else
            bg_job_status # => {status: 'complete', update_time: 1360006573, vino: 'veritas'}
            case bg_job_status["status"]
            when "complete"
              tree = current_user.trees.find_by_id(tree_id.to_i)
              data = {status: tree.status, tree_id: tree_id}.to_json
            when "failed", "interrupted"
              logger.info "Job failed or interrupted"
            end
          end
          tubesock.send_data "#{data}"
        else
          data = {status: tree.status, tree_id: tree_id}.to_json
          tubesock.send_data "#{data}"
        end
      end
    end
  end
end



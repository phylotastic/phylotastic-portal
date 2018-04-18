require 'test_helper'

class TrackersControllerTest < ActionController::TestCase
  include Tubesock::Hijack

  def track
    hijack do |tubesock|
      tubesock.onopen do
        tubesock.send_data "Hello, friend"
      end

      tubesock.onmessage do |data|
        tubesock.send_data "You said: #{data}"
      end
    end
  end
end

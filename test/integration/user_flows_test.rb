require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test "can log in" do
    get "/"
    assert_select "h1", "Welcome#index"
    sign_in users(:one)
    sign_out :one
  end
end

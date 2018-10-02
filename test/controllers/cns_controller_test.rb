require 'test_helper'

class CnsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cns_new_url
    assert_response :success
  end

end

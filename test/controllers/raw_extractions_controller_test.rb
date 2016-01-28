require 'test_helper'

class RawExtractionsControllerTest < ActionController::TestCase
  test "should get new_from_file_and_web" do
    get :new_from_file_and_web
    assert_response :success
  end

end

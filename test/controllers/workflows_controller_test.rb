require 'test_helper'

class WorkflowsControllerTest < ActionDispatch::IntegrationTest
  test "should get scale_sdm" do
    get workflows_scale_sdm_url
    assert_response :success
  end

end
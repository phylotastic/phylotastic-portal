require 'test_helper'

class WorkflowsControllerTest < ActionDispatch::IntegrationTest
  test "should get scale_sdm" do
    get workflows_scale_sdm_url(id: 1)
    assert_response :success
  end

end

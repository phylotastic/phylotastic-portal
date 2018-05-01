require 'test_helper'

class DcasControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_dca_path
    assert_response :success
    assert_select "title", "Create trees from DCA | Phylotastic Portal"
  end

  test "should not be created" do
    post "/dcas",
      params: { dca: { file: "" } }
      assert_response :success
      assert_select "div#error_explanation h4", "The form contains 1 error:"
  end
  
  test "should be created" do
    post "/dcas", params: { dca: { file: fixture_file_upload('t.zip') } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "a.list-group-item", text: "t.zip"
    assert_response :success
  end

end

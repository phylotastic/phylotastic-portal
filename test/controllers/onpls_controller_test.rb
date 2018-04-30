require 'test_helper'

class OnplsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_onpl_path
    assert_response :success
    assert_select "title", "Create trees from files that have one name per line | Phylotastic Portal"
  end

  test "should not be created" do
    post "/onpls",
      params: { onpl: { file: "" }, name: "", description: "" }
      assert_response :success
      assert_select "div#error_explanation h4", "The form contains 1 error:"
  end
  
  test "should be created" do
    post "/onpls",
      params: { onpl: { file: fixture_file_upload('t.txt') }, 
                name: lists(:one).name, 
                description: "A list of fish species" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "a.list-group-item", text: lists(:one).name
    assert_response :success
  end

end

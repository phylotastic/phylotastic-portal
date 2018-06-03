require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_document_path
    assert_response :success
    assert_select "title", "Create trees from files | Phylotastic Portal"
  end

  test "should not be created" do
    post "/documents",
      params: { document: { file: "" }, name: "", description: "" }
      assert_response :success
      assert_select "div#error_explanation h4", "The form contains 3 errors:"
  end
  
  test "should be created" do
    post "/documents",
      params: { document: { file: fixture_file_upload('t.txt'),
                            method: "NetiNeti"
                          }, 
                name: lists(:one).name, 
                description: "A list of fish species" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "a.list-group-item", text: lists(:one).name
    assert_select "li", text: lists(:one).name + " list is created!"
  end

end

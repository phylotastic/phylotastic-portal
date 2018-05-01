require 'test_helper'

class TaxonomiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_taxonomy_path
    assert_response :success
    assert_select "title", "Create trees from taxonomy | Phylotastic Portal"
  end

  test "should not be created" do
    post "/taxonomies",
      params: { taxonomy: { taxon: "" }, name: "", description: "" }
      assert_response :success
      assert_select "div#error_explanation h4", "The form contains 1 error:"
  end
  
  test "should be created" do
    post "/taxonomies",
      params: { taxonomy: { taxon: "Myrmecia" }, 
                name: lists(:one).name, 
                description: "A list of fish species" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "a.list-group-item", text: lists(:one).name
    assert_response :success
  end
  
end

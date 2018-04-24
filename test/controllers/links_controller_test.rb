require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_link_path
    assert_response :success
    assert_select "title", "Create trees from online sources | Phylotastic Portal"
  end

  test "should not be created" do
    post "/links",
      params: { link: { url: "" }, name: "", description: "" }
      assert_response :success
      assert_select "div#error_explanation h4", "The form contains 1 error:"
  end
  
  test "should be created" do
    post "/links",
      params: { link: { url: links(:fish_link).url }, name: "Fish", description: "A list of fish species" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "p", "Title:\n  Fish"
    assert_response :success
  end

  test "should get destroy" do
    get links_destroy_url
    assert_response :success
    assert_text "Link is removed"
  end

end

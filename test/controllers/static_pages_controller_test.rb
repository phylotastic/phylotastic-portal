require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Phylotastic Portal"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Phylotastic Portal"
  end
  
  test "should get feedback" do
    get static_pages_feedback_url
    assert_response :success
    assert_select "title", "Feedback | Phylotastic Portal"
  end
end

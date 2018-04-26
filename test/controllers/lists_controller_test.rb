require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get lists_edit_url
    assert_response :success
  end

  test "should get update" do
    get lists_update_url
    assert_response :success
  end

  test "should get index" do
    get lists_path
    assert_response :success
    assert_select "title", "Home | Phylotastic Portal"
  end

  test "should get destroy" do
    get lists_destroy_url
    assert_response :success
  end

end

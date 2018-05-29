require 'test_helper'

class TreesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trees_index_url
    assert_response :success
  end

  test "should get show" do
    get trees_show_url
    assert_response :success
  end

  test "should get create" do
    get trees_create_url
    assert_response :success
  end

  test "should get edit" do
    get trees_edit_url
    assert_response :success
  end

  test "should get update" do
    get trees_update_url
    assert_response :success
  end

  test "should get destroy" do
    get trees_destroy_url
    assert_response :success
  end

end

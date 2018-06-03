require 'test_helper'

class TreesControllerTest < ActionDispatch::IntegrationTest

  # test "should get show" do
  #   get trees_show_url
  #   assert_response :success
  # end

  test "should get create" do
    post "/lists/1/trees",
      params: { 
        tree: { 
          name: "aaa", 
          list_from_service: "false", 
          species: {
            "Ponthieva racemosa":"1", 
            "Spiranthes infernalis":"1", 
            "Vanilla inodora":"1", 
            "Tipularia discolor":"1", 
            "Platanthera praeclara":"1"
          }
        }, 
        list_id: "15"
      }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "li.active", text: "aaa"
  end

  # test "should get edit" do
  #   get edit_tree_url
  #   assert_response :success
  # end
  #
  # test "should get update" do
  #   get trees_update_url
  #   assert_response :success
  # end
  #
  # test "should get destroy" do
  #   get trees_destroy_url
  #   assert_response :success
  # end

end

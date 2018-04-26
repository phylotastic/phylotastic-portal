require "application_system_test_case"

class GuestsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:one)
    Warden.test_mode!
    # login_as(@user, scope: :user)
  end
  
  test "creating a link without logging in" do
    visit new_link_path
 
    fill_in "URL", with: links(:fish_link).url
    fill_in "Name", with: lists(:one).name

    click_on "Submit"

    assert_text "Hello, Guest"
    assert_text lists(:one).name
    assert_selector "a.list-group-item", text: lists(:one).name
  end
  
  test "creating a link without logging in then logging in" do
    visit new_link_path
 
    fill_in "URL", with: links(:fish_link).url
    fill_in "Name", with: lists(:one).name

    click_on "Submit"

    assert_text "Hello, Guest"
    assert_text lists(:one).name
    assert_selector "a.list-group-item", text: lists(:one).name
    
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on "Log in"
            
    assert_text "Hello, " + users(:one).email
    assert_text lists(:one).name
    assert_selector "a.list-group-item", text: lists(:one).name  
  end
  
  teardown do
    Warden.test_reset!
  end
end

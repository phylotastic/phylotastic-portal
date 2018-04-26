require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:one)
    Warden.test_mode!
    login_as(@user, scope: :user)
  end
  
  test "can log in" do
    get "/"
    assert_select "a.dropdown-toggle", "Hello, " + users(:one).email
    # user = User.create(email: "t@m.c", password: "123456")
    # binding.pry
    # assert_select "a.dropdown-toggle", "Hello, Guest"
    # sign_in user
    # sign_out user
    # assert_select "a.dropdown-toggle", "Hello, Guest"
  end
  
  teardown do
    Warden.test_reset!
  end
end

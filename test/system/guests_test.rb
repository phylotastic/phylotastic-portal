require "application_system_test_case"

class GuestsTest < ApplicationSystemTestCase
  test "creating a link without logging in" do
    visit new_link_path
 
    fill_in "URL", with: links(:fish_link).url
    fill_in "Name", with: lists(:one).name

    click_on "Submit"

    assert_text "Hello, Guest"
    assert_select "div.list", lists(:one).name
  end
end

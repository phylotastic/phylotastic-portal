require 'spec_helper'

feature "lets the user", js: true do
  before do
    visit 'http://0.0.0.0:3000/con_links/new'
  end
  
  it 'submit a list from web link' do
    fill_in 'con_link[uri]', with: 'https://en.wikipedia.org/wiki/Greenland_Dog'
    fill_in 'con_link[name]', with: 'Greenland Dog'
    # page.save_screenshot
    click_button "Get list"
    expect(page).to have_content('Processing')
    # page.save_screenshot
  end
end

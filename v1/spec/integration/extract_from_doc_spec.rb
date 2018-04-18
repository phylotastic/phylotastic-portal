require 'spec_helper'

feature "lets the user", js: true do
  before do
    visit 'http://0.0.0.0:3000/con_taxons/new'
  end
  
  it 'submit a list from doc' do
    fill_in 'taxon', with: 'Canidae'
    fill_in 'name', with: 'Canidae'
    page.save_screenshot
    click_button "Get list"
    expect(page).to have_content('Processing')
    page.save_screenshot
  end
end

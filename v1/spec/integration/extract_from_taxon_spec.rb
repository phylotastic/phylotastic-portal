require 'spec_helper'

feature "lets the user", js: true do
  before do
    visit 'http://0.0.0.0:3000/con_files/new'
  end
  
  it 'submit a list from doc' do
    page.execute_script("document.getElementById('con_file_document').style.opacity = 1")
    attach_file("con_file[document]", Rails.root + "spec/fixtures/file.txt")
    fill_in 'con_file[name]', with: 'Species'
    page.save_screenshot
    click_button "Get list"
    expect(page).to have_content('Processing')
    page.save_screenshot
  end
end

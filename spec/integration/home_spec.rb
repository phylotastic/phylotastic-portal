require 'spec_helper'

feature 'home page' do
  it 'welcomes the user' do
    visit '/'
    expect(page).to have_content "Welcome"
  end
end

feature 'home page' do
  it 'welcomes the user' do
    visit 'http://0.0.0.0:3000/static_pages/about'
    expect(page).to have_content "What we do"
  end
end


feature "lets the user", js: true do
  before do
    visit 'http://0.0.0.0:3000'
  end
  
  it 'select a public list' do
    page.all(".list-group-item").last.click
    expect(page).to have_content "Top 40 popular species"
    expect(page).to have_content "Acinonyx jubatus"
  end
  
  it 'push \"Get tree\" button' do
    page.all(".list-group-item").last.click
    click_button "Get tree"
    expect(page).to have_selector('.modal-body', visible: true)
    within(find(".modal-body")) do
      fill_in 'tree_name-9', with: 'Capybana test'
    end
    find("#psedo-submit-9").click
    page.save_screenshot
    expect(page).to have_content('Extracting tree')
  end
end

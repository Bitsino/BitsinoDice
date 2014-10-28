require "rails_helper"

feature 'User registration and logon' do
  scenario 'can we register correctly', :js => true do
    
    visit root_path
    
    page.save_screenshot('tmp/screenshot.png')
    
  end
end
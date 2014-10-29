require "rails_helper"

feature 'User registration and logon' do
  scenario 'can we register correctly', :js => true do
    
    u = FactoryGirl.create(:cold_storage)
    u = FactoryGirl.create(:user)
    
    visit root_path
    
    click_on "Register / Login"
    
    fill_in 'user_username', with: 'majorgambler'
    fill_in 'user_password', with: 'abigpassword'
    
    click_on "Register"
    
    expect(page.find('#username').value).to eq('majorgambler')
    
    # Now login as someone else
    
    page.save_screenshot('tmp/screenshot.png')
  end
end
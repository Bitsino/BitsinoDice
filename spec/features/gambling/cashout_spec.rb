include Warden::Test::Helpers
Warden.test_mode!

feature 'When cashing out.', :js => true do
  
  after(:each) do
    Warden.test_reset!
  end

  scenario 'does the data get saved' do
    user = FactoryGirl.create(:user)
    user = FactoryGirl.create(:balance)
    signin('test@example.com', 'please123')
    
    click_on 'Cashout'
    
    fill_in 'address', with: '38BqfF4LUgpbvoYbGpyYAw44qrpS841GA1'
    fill_in 'amount', with: '0.001'
    
    page.save_screenshot('tmp/screenshot.jpg')
    
    page.find('#cashout-button').click
    
    click_on 'Transaction History'
    
  end

end

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
  end

end

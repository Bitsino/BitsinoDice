include Warden::Test::Helpers
Warden.test_mode!

feature 'When cashing out.', :js => true do
  
  after(:each) do
    Warden.test_reset!
  end

  scenario 'does the data get saved' do
    skip "Not yet complete"
  end

end

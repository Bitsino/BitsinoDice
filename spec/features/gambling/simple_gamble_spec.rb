include Warden::Test::Helpers
Warden.test_mode!

feature 'Gambling', :js => true do
  
  after(:each) do
    Warden.test_reset!
  end

  scenario 'user has signed in and just hits roll dice' do
    user = FactoryGirl.create(:user)
    signin('test@example.com', 'please123')
    
    expect(page.all('tbody#bets tr').count).to eq(0)
    
    click_on "Roll Dice"
    
    expect(page.all('tbody#bets tr').count).to eq(1)
    
    tr = page.find('tbody#bets tr')
    
    expect(tr.all('td')[0].text).to eq("1")
    expect(tr.all('td')[1].text).to eq("Test User")
  end

end

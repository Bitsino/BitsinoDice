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
    expect(tr.all('td')[2].text).to eq("less than a minute ago.")
    expect(tr.all('td')[3].text).to eq("0.0")
    expect(tr.all('td')[4].text).to eq("2.0")
    expect(tr.all('td')[5].text).to eq("< 49.5")
    expect(tr.all('td')[7].text).to eq("0.0")
  end

end

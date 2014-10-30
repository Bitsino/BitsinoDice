include Warden::Test::Helpers
Warden.test_mode!

feature 'When gambling', :js => true do
  
  after(:each) do
    Warden.test_reset!
  end

  scenario 'can the user sign in and roll the dice' do
    user = FactoryGirl.create(:user)
    signin('test@example.com', 'please123')
    
    expect(page.all('tbody#bets tr').count).to eq(0)
    
    page.find("#roll-button").click
    
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
  
  scenario 'does the users balance increase or decrease with each bet' do
    user = FactoryGirl.create(:user)
    signin('test@example.com', 'please123')
    
    bal_before = page.find('#balance').value
    
    page.find("#roll-button").click

    bal_after = page.find('#balance').value
    
    expect(bal_before).not_to eq(bal_after)
  end
  
  scenario 'does the probability slider work.' do
    user = FactoryGirl.create(:user)
    signin('test@example.com', 'please123')
    
    page.execute_script("$('#probability-slider').simpleSlider('setValue', 80);")
    
    prob = page.find('#bet_chance').value
    
    expect(prob).to eq("80.0%")
    
    button = page.find('#roll-button').value
    
    expect(button).to eq("Click for a 80.0% chance of multiplying your bet by 1.24")
    
    # OK, Make the bet.
    page.find("#roll-button").click
    
    expect(page.all('tbody#bets tr').count).to eq(1)
    
    tr = page.find('tbody#bets tr')
    
    expect(tr.all('td')[0].text).to eq("1")
    expect(tr.all('td')[1].text).to eq("Test User")
    expect(tr.all('td')[2].text).to eq("less than a minute ago.")
    expect(tr.all('td')[3].text).to eq("0.0")
    expect(tr.all('td')[4].text).to eq("1.24")
    expect(tr.all('td')[5].text).to eq("< 80.0")
    expect(tr.all('td')[7].text).to eq("0.0")
    
  end

end

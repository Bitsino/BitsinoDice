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
    
    page.save_screenshot('tmp/screenshot.png')
    
    expect(page.all('tbody#bets tr').count).to eq(1)
    
    tr = page.find('tbody#bets tr')
    
    expect(tr.all('td')[0].text).to eq("1")
    expect(tr.all('td')[1].text).to eq("Test User")
    expect(tr.all('td')[2].text).to eq("less than a minute ago.")
    expect(tr.all('td')[3].text).to eq("0.00000000")
    expect(tr.all('td')[4].text).to eq("2.0")
    expect(tr.all('td')[5].text).to eq("< 49.5")
    expect(tr.all('td')[7].text).to eq("0.00000000")
  end
  
  scenario 'is the balance displaying correctly.' do
    user = FactoryGirl.create(:user)
    user = FactoryGirl.create(:balance)
    signin('test@example.com', 'please123')
    
    bal = page.find('#balance').value
    
    expect(bal).to eq('0.005')
  end
  
  scenario 'does the users balance increase or decrease with each bet' do
    user = FactoryGirl.create(:user)
    user = FactoryGirl.create(:balance)
    signin('test@example.com', 'please123')
    
    bal_before = page.find('#balance').value
    
    page.find("#roll-button").click

    bal_after = page.find('#balance').value
    
    expect(bal_before).to eq(bal_after)
    
    # OK let's slide the amount slider and see what happens
    page.execute_script("$('#amount-slider').val(20000);$('#amount-slider').change()")
    
    page.find("#roll-button").click

    bal_after = page.find('#balance').value
    
    expect(bal_before).to_not eq(bal_after)
  end
  
  scenario 'does the amount slider work.' do
    
    user = FactoryGirl.create(:user)
    user = FactoryGirl.create(:balance)
    signin('test@example.com', 'please123')
    
    page.execute_script("$('#amount-slider').val(10000);$('#amount-slider').change()")
    
    amount = page.find('#amount-view').value
    
    expect(amount).to eq("0.00010")
    
    button = page.find('#roll-button').value
    
    expect(button).to eq("Click for a 49.5% chance of multiplying your bet by 2.00")
    
    # OK, Make the bet.
    page.find("#roll-button").click
    
    expect(page.all('tbody#bets tr').count).to eq(1)
    
    tr = page.find('tbody#bets tr')
    
    expect(tr.all('td')[0].text).to eq("1")
    expect(tr.all('td')[1].text).to eq("Test User")
    expect(tr.all('td')[2].text).to eq("less than a minute ago.")
    expect(tr.all('td')[3].text).to eq("0.0001")
    expect(tr.all('td')[4].text).to eq("2.0")
    expect(tr.all('td')[5].text).to eq("< 49.5")
    
  end
  
  scenario 'does the probability slider work.' do
    user = FactoryGirl.create(:user)
    signin('test@example.com', 'please123')
    
    page.execute_script("$('#probability-slider').val(80);$('#probability-slider').change()")
    
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
    expect(tr.all('td')[3].text).to eq("0.00000000")
    expect(tr.all('td')[4].text).to eq("1.24")
    expect(tr.all('td')[5].text).to eq("< 80.0")
    expect(tr.all('td')[7].text).to eq("0.00000000")
    
  end

end

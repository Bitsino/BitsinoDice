include Warden::Test::Helpers
Warden.test_mode!

feature 'When hacking' do
  
  after(:each) do
    Warden.test_reset!
  end

  scenario 'can a user bet more than their balance.' do
    user = FactoryGirl.create(:user)
    user = FactoryGirl.create(:balance)
    
    signin('test@example.com', 'please123')
    
    find("#amount-hidden").set "1000000"
    
    page.find("#roll-button").click
    
    b = Bet.all
    
    expect(b.count).to eq(0)
  end

  scenario 'can a bet more than our limit.' do
    user = FactoryGirl.create(:user)
    user = FactoryGirl.create(:balance, :big_spender)
    
    signin('test@example.com', 'please123')
    
    # Bet above the limit
    find("#amount-hidden").set "200000000"
    
    page.find("#roll-button").click
    
    b = Bet.all
    
    expect(b.count).to eq(0)
    
    # Bet just below the limit
    find("#amount-hidden").set "9999999"
    
    page.find("#roll-button").click
    
    b = Bet.all
    
    expect(b.count).to eq(1)
  end

end

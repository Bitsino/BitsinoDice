describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

  it "#sweep_bitcoins_to_onchain_fund should create a valid tx" do
    
    tx = User.sweep_bitcoins_to_onchain_fund
    
  end
end

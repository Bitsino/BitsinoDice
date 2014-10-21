class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates :username, uniqueness: { case_sensitive: false }

  has_many :bets
  has_many :transactions
  has_many :cashouts
  has_many :balances

  before_create :generate_auth_token

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def as_json(options = {})
    {
      username: username,
      auth_token: auth_token,
      id: id,
      address: address,
      balance: balance
    }
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def balance
    bal = 0
    balances.each{ |balance| bal = bal + balance.amount }
    return bal
  end
  
  def self.sweep_for_incoming_coins
    
    block = ColdStorage.first.block
    if block == nil
      block = 0
    end
    count = User.count
    keys = ColdStorage.first.get_extended_keys
    
    puts "Sweeping #{count} users starting from block #{block}"
    incoming, block_end = OnChain::Sweeper.sweep(keys, 'm/#{index}', count, block)
    
    ActiveRecord::Base.transaction do
      incoming.each do |coins|
        puts coins
        u = User.find_by_address(coins[0])
        
        bal = u.balances.new
        bal.transaction_hash = coins[3] 
        bal.amount = coins[2].to_i
        bal.save
      end
      cs = ColdStorage.first
      cs.block = block_end
      cs.save
    end
  end
  
  protected 

  def generate_auth_token
    self.auth_token = SecureRandom.hex(24)
  end

end

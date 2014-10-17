class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates :username, uniqueness: { case_sensitive: false }

  has_many :bets
  has_many :transactions
  has_many :cashouts

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
  
  def self.sweep_for_incoming_coins
    
    block = ColdStorage.first.block
    if block == nil
      block = 0
    end
    count = User.count
    keys = ColdStorage.first.get_extended_keys
    
    puts keys
    
    puts "Sweeping #{count} users starting from block #{block}"
    incoming, block_end = OnChain::Sweeper.sweep(keys, 'm/#{index}', count, block)
    
    ActiveRecord::Base.transaction do
      incoming.each do |coins|
        puts coins[0]
        u = User.find_by_address(coins[0])
        bal = u.balance
        if bal == nil
          bal = 0
        end
        bal= bal + coins[2]
        u.balance = bal
        u.save
      end
      cs = ColdStorage.first
      cs.block = block
      cs.save
    end
  end
  
  protected 

  def generate_auth_token
    self.auth_token = SecureRandom.hex(24)
  end

end

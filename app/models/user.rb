class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates :username, uniqueness: { case_sensitive: false }

  has_many :bets
  has_many :transactions

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
    User.all.each do |user|
      
      # lock the user, in case they are gambling right now.
      user.with_lock do
        res = OnChain.get_transactions(user.address)
        res.each do |tx|
          if tx[0] == user.last_transaction_hash
            next
          end
          user.balance = user.balance + tx[1].to_d
          user.last_transaction_hash = tx[0]
        end
        if user.changed?
          user.save
        end
      end
    end
  end
  
  protected 

  def generate_auth_token
    self.auth_token = SecureRandom.hex(24)
  end

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates :username, uniqueness: { case_sensitive: false }

  has_many :bets

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
      res = blockr('address/txs', user.address)
      puts res['data']
      res['data']['txs'].each do |tx|
        if tx['tx'] == user.last_transaction_hash
          next
        end
        user.balance = user.balance + tx['amount'].to_d
        user.last_transaction_hash = tx['tx']
      end
      if user.changed?
        user.save
      end
    end
  end
  
  protected 
  
  def self.blockr(cmd, address, params = "")
    begin
      base_url = "http://blockr.io/api/v1/#{cmd}/#{address}" + params
      fetch_response(base_url, true)
    rescue
      blockr_is_down
    end
  end
  
  def self.fetch_response(url, do_json=true)
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
  
    if do_json
      result = JSON.parse(data)
    else
      data
    end
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex(24)
  end

end

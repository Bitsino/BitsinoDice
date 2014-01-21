class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates :username, uniqueness: { case_sensitive: false }

  attr_encrypted :pkey, :key => ENV['ENC_KEY']

  has_many :bets

  before_create :assign_address
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
    @balance ||= Net::HTTP.get_response(URI.parse("http://blockchain.info/q/addressbalance/#{address}?confirmations=1")).body.to_i.from_satoshi
  end

  protected

    def assign_address
      self.address, self.pkey = Net::HTTP.get_response(URI.parse('http://blockchain.info/q/newkey')).body.split(' ')
    end

    def generate_auth_token
      self.auth_token = SecureRandom.hex(24)
    end

end

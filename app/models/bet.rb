class Bet < ActiveRecord::Base

  belongs_to :user
  belongs_to :secret

  before_create :calculate_roll
  after_create  :make_payment

  def as_json(options = {})
    {
      id: id,
      amount: amount,
      multiplier: multiplier,
      game: game,
      rolltype: rolltype == 'under' ? '<' : '>',
      roll: roll.round(2),
      profit: win? ? profit : 0,
      win_or_lose: win? ? 'win' : 'lose',
      created_at: created_at,
      username: user.try(:username) || 'Guest'
    }
  end

  def profit
    (amount * multiplier) - amount
  end

  def win?
    if rolltype == 'under'
      roll < game
    else
      roll > game
    end
  end

  protected

    def calculate_roll
      str  = [secret.secret, server_seed, client_seed].join
      hash = Digest::SHA512.hexdigest(str)

      self.roll = (hash[0, 8].hex / 42949672.95).round(2)
    end

    def make_payment
      return if user.nil?

      if win? 
        Cashout.perform(user.pkey, user.address, profit.in_satoshi)
      else
        Cashout.perform(ENV['PKEY'], ENV['FEE_ADDRESS'], amount.in_satoshi)
      end
    end
  
end

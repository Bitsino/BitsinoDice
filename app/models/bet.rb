class Bet < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :secret

  before_create :calculate_roll
  after_create  :update_balance

  def as_json(options = {})
    {
      id: id,
      username: user.try(:name) || 'Guest',
      amount: amount_formatted,
      multiplier: multiplier.round(2),
      game: game,
      rolltype: rolltype == 'under' ? '<' : '>',
      roll: roll.round(2),
      profit: profit_formatted,
      win_or_lose: win? ? 'win' : 'lose',
      created_at: time_ago_in_words(created_at) + ' ago',
    }
  end
  
  def multiplier
   return (99 / game)
  end

  def profit
    if win?
      return ((amount.to_d * (multiplier).to_d) - amount.to_d).to_i
    else
      return -amount
    end
  end

  def win?
    if rolltype == 'under'
      roll < game
    else
      roll > game
    end
  end
  
  def self.latest_bets
    bets = Bet.order('created_at DESC').limit(25)
  end
  
  def profit_formatted
    return format_btc(profit)
  end
  
  def amount_formatted
    return format_btc(amount)
  end
  
  def format_btc(amount)
    if amount < 10000
      return "%.8f" % (amount / 100000000.0)
    end
    return amount / 100000000.0
  end

  protected

    def calculate_roll
      
      # Combine all the secrets.
      str  = [secret.secret, server_seed, client_seed].join
      
      # Generate a hexadecimal hash.
      hash = Digest::SHA512.hexdigest(str)

      # Generate a number between 0 and 9999 inclusive.
      one_and_ten_thousand = hash.hex % 10000
      
      # Conver it to a 2 decimal point number between 0 and 99.99
      self.roll = one_and_ten_thousand / 100.0
    end

    def update_balance
      return if user.nil?

      b = user.balances.new
      b.transaction_hash = "Bet #{id}"
      
      if win?
        b.amount = profit
      else
        b.amount = (- amount)
      end
      
      if b.amount != 0
        b.save
      end
    end

    def make_payment
      return if user.nil?

      if win?
        Cashout.perform(ENV['PKEY'], user.address, profit.in_satoshi)
      else
        Cashout.perform(user.pkey ENV['FEE_ADDRESS'], amount.in_satoshi)
      end
    end
  
end

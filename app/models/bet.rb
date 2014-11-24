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
      amount: amount / 100000000.0,
      multiplier: multiplier,
      game: game,
      rolltype: rolltype == 'under' ? '<' : '>',
      roll: roll.round(2),
      profit: profit / 100000000.0,
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

  protected

    def calculate_roll
      str  = [secret.secret, server_seed, client_seed].join
      hash = Digest::SHA512.hexdigest(str)

      self.roll = (hash[0, 8].hex / 42949672.95).round(2)
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
      
      b.save
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

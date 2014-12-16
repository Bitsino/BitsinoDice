class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :bets
  has_many :transactions
  has_many :cashouts
  has_many :balances

  def balance
    bal = 0
    balances.each{ |balance| bal = bal + balance.amount }
    return bal
  end

  def balance_as_btc
    (balance / 100000000.0)
  end
  
  def self.get_cold_storage
    cs = ColdStorage.first
    if cs == nil
      cs = ColdStorage.create
      cs.save
    end
    return cs
  end
  
  def self.sweep_for_incoming_coins
    
    block = get_cold_storage.block
    if block == nil
      block = 0
    end
    count = User.count
    keys = ColdStorage.get_extended_keys
    
    puts "Sweeping #{count} users starting from block #{block}"
    incoming, block_end = OnChain::Sweeper.sweep(keys.count, keys, 'm/#{index}', count, block)
    
    ActiveRecord::Base.transaction do
      incoming.each do |coins|
        u = User.find_by_bitcoin_address(coins[0])
        
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
  
  def self.sweep_bitcoins_to_onchain_fund
    
    block = get_cold_storage.sweep_block
    if block == nil
      block = 0
    end
    count = User.count
    keys = ColdStorage.get_extended_keys
    
    puts "Sweeping #{count} users starting from block #{block}"
    incoming, block_end = OnChain::Sweeper.sweep(keys.length, keys, 'm/#{index}', count, block)

    cs = ColdStorage.first
    cs.sweep_block = block_end
    cs.save
    
    tx, paths = OnChain::Sweeper.create_payment_tx_from_sweep(keys.length, incoming, ColdStorage.get_fund_address, keys)
    
    puts ENV['ONCHAIN_EMAIL']
    
    if tx != 'Not enough coins to create a transaction.'
      
      OnChain::Sweeper.post_tx_for_signing(tx, paths, ColdStorage.get_fund_address)
      
      return true
    end
    return false
  end
end

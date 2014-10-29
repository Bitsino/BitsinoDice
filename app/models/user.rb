class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :bets
  has_many :transactions
  has_many :cashouts
  has_many :balances
  
  def address

    return OnChain::Sweeper.multi_sig_address_from_mpks(
      ColdStorage.get_extended_keys, "m/#{id}")
      
  end

  def balance
    bal = 0
    balances.each{ |balance| bal = bal + balance.amount }
    return bal / 100000000.0
  end
  
  def self.sweep_for_incoming_coins
    
    block = ColdStorage.first.block
    if block == nil
      block = 0
    end
    count = User.count
    keys = ColdStorage.get_extended_keys
    
    puts "Sweeping #{count} users starting from block #{block}"
    incoming, block_end = OnChain::Sweeper.sweep(keys, 'm/#{index}', count, block)
    
    ActiveRecord::Base.transaction do
      incoming.each do |coins|
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
  
  def self.sweep_bitcoins_to_onchain_fund
    
    block = ColdStorage.first.sweep_block
    if block == nil
      block = 0
    end
    count = User.count
    keys = ColdStorage.first.get_extended_keys
    
    puts "Sweeping #{count} users starting from block #{block}"
    incoming, block_end = OnChain::Sweeper.sweep(keys, 'm/#{index}', count, block)

    cs = ColdStorage.first
    cs.block = block_end
    cs.save
    
    tx = OnChain::Sweeper.create_payment_tx_from_sweep(incoming, '3GzGsZ5zFWsFR5LU8TYntptkZqvZrPWzw5')
    
    puts tx
  end
end

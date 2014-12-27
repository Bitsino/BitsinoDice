class Cashout < ActiveRecord::Base
  
  def self.create_onchain_payment_request
    
    # Collect all the payouts inyo an array of address,amount
    cashouts = Cashout.where('status is null')
    payees = cashouts.map { |c| [c.address, c.amount] }
    
    
    # No one to pay out to ?
    if payees.count == 0
      return
    end
    
    total = Cashout.all.inject(0){|sum,c| sum += c.amount }
    
    puts "Paying out " + total.to_s
    
    # Get the redmption script for our fund
    rs  = ColdStorage.redemption_script
    
    # Create a transaction for the lucky winners :)
    # or unlucky for us. :(
    tx = OnChain::Payments.create_payment_tx(rs, payees)
    
    # Did we get an error back ?
    if tx.is_a? String
      puts tx
    else
      # Update the cashout status
      cashouts.each do |cashout|
        cashout.status = true
        cashout.save
      end
      
      # Forward the TX to onchain for signing.
      tx_hex = OnChain.bin_to_hex(tx.to_payload)
      OnChain::Sweeper.post_tx_for_signing(tx_hex, [], ColdStorage.get_fund_address)
    end
  end
end

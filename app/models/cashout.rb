class Cashout < ActiveRecord::Base
  
  def self.create_onchain_payment_request
    
    # Collect all the payouts inyo an array of address,amount
    cashouts = Cashout.where('status is null')
    payees = cashouts.map { |c| [c.address, c.amount] }
    
    # No one to pay out to ?
    if payees.count == 0
      return
    end
    
    # Get the redmption script for our fund
    rs  = ColdStorage.redemption_script
    
    # Create a transaction for the lucky winners :)
    # or unlucky for us. :(
    tx = OnChain::Payments.create_payment_tx(rs, payees)
    
    # Did we get an error back ?
    if tx.is_a? String
      puts tx
    else
      tx_hex = OnChain.bin_to_hex(tx.to_payload)
      OnChain::Sweeper.post_tx_for_signing(tx_hex, [], ColdStorage.get_fund_address)
    end
  end
end

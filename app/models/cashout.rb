class Cashout

  def self.perform(pkey, recipient, amount)
    Rails.logger.error "!!! - Payment of #{amount.to_s}"
    amount     = amount - ENV['TX_FEE'].to_d.in_satoshi
    Rails.logger.error "!!! - Payment of #{amount.to_s}"
    return if amount <= 0
    
    attributes = { to: recipient, amount: amount }
    
    uri        = URI.parse("https://blockchain.info/merchant/#{pkey}/payment")
    response   = Net::HTTP.post_form(uri, attributes)

    Rails.logger.error "!!! - Payment of #{amount} sent to #{recipient}"
    Rails.logger.error "!!! - #{response.body}"

    response.body
  end

end
class Cashout

  def self.perform(pkey, recipient, amount)
    attributes = { address: recipient, amount: (amount * 100000000.0) }
    uri        = URI.parse("https://blockchain.info/merchant/#{pkey}/payment")
    response   = Net::HTTP.post_form(uri, attributes)

    Rails.logger.error "!!! - Payment of #{amount} sent to #{recipient}"
    Rails.logger.error "!!! - #{response.body}"

    response.body
  end

end
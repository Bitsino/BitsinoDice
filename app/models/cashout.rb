class Cashout

  def self.perform(pkey, recipient, amount)
    attributes = { address: recipient, amount: (amount * 100000000.0) }
    uri        = URI.parse("https://blockchain.info/merchant/#{pkey}/payment")
    response   = Net::HTTP.post_form(uri, attributes)

    Rails.logger.info "Payment of #{amount} sent to #{recipient}"

    response.body
  end

end
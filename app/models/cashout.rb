class Cashout

  def self.perform(pkey, recipient, amount)
    attributes = { address: recipient, amount: (amount * 100000000) }
    response   = Net::HTTP.post_form("https://blockchain.info/merchant/#{pkey}/payment", attributes)

    Rails.logger.info "Payment of #{amount} sent to #{address}"

    response
  end

end
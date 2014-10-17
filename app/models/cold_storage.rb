class ColdStorage < ActiveRecord::Base
  
  validates :mpk, presence: true
  validates :fund_address, presence: true
  
  self.table_name = 'cold_storage'
  def get_addresses 
    mpks = mpk.split("\r\n")
    
    addresses = []
    mpks.each do |mpk|
      master = MoneyTree::Node.from_serialized_address(mpk)
      addresses << master.public_key.to_hex
    end
    return addresses
  end
  
  def get_extended_keys
    return mpk.split("\r\n")
  end
  
  def redemption_script
    return OnChain::Sweeper.generate_redemption_script(get_addresses)
  end
end
class ColdStorage < ActiveRecord::Base
  
  self.table_name = 'cold_storage'
  def self.get_addresses 
    mpks = Figaro.env.master_public_keys.split(",")
    
    addresses = []
    mpks.each do |mpk|
      master = MoneyTree::Node.from_serialized_address(mpk)
      addresses << master.public_key.to_hex
    end
    return addresses
  end
  
  def self.get_extended_keys
    return Figaro.env.master_public_keys.split(",")
  end
  
  def redemption_script
    return OnChain::Sweeper.generate_redemption_script(get_addresses)
  end
end
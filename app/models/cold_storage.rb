class ColdStorage < ActiveRecord::Base

  
  validates :mpk, presence: true
  validates :fund_address, presence: true
  
  self.table_name = 'cold_storage'
end
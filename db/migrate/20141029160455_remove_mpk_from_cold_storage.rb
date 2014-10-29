class RemoveMpkFromColdStorage < ActiveRecord::Migration
  def change
    remove_column :cold_storage, :mpk, :string
    remove_column :cold_storage, :fund_address, :string
  end
end

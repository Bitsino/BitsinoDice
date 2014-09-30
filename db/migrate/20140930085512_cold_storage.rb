class ColdStorage < ActiveRecord::Migration
  def change
    create_table(:cold_storage) do |t|
      ## Database authenticatable
      t.string :mpk
      t.string :fund_address
    end
  end
end

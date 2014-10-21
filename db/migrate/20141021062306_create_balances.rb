class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.string :transaction
      t.integer :amount
      t.integer :user_id

      t.timestamps
    end
  end
end

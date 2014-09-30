class AddLastTransactionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_transaction_hash, :string
  end
end

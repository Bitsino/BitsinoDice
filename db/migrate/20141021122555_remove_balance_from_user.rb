class RemoveBalanceFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :balance, :decimal
  end
end

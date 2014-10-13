class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :amount
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end

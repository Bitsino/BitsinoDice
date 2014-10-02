class CreateCashouts < ActiveRecord::Migration
  def change
    create_table :cashouts do |t|
      t.string :address
      t.integer :amount
      t.boolean :status

      t.timestamps
    end
  end
end

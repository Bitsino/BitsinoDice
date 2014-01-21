class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.references :user
      t.references :secret
      t.decimal :amount, scale: 8, precision: 15
      t.decimal :multiplier, scale: 4, precision: 8
      t.decimal :game, scale: 2, precision: 4
      t.decimal :roll, scale: 2, precision: 4
      t.string :rolltype, default: 'under'
      t.string :client_seed
      t.string :server_seed
      t.timestamps
    end
  end
end

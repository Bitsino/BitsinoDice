class AddUniqueConstraintToServerSeed < ActiveRecord::Migration
  def change
    add_index(:bets, :server_seed, :unique => true)
  end
end

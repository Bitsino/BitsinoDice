class RemoveMultiplierFromBets < ActiveRecord::Migration
  def change
    remove_column :bets, :multiplier, :string
  end
end

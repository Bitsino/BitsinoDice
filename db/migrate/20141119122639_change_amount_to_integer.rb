class ChangeAmountToInteger < ActiveRecord::Migration
  def change
    change_table :bets do |t|
      t.change :amount, :integer
    end
  end
end

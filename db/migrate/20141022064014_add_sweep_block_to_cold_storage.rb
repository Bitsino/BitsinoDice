class AddSweepBlockToColdStorage < ActiveRecord::Migration
  def change
    add_column :cold_storage, :sweep_block, :integer
  end
end

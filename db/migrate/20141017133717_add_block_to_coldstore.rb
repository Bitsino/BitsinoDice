class AddBlockToColdstore < ActiveRecord::Migration
  def change
    add_column :cold_storage, :block, :integer
  end
end

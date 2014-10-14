class AddUserIdToCashouts < ActiveRecord::Migration
  def change
    add_column :cashouts, :user_id, :integer
  end
end

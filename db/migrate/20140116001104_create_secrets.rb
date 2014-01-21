class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.string :secret
      t.timestamps
    end
  end
end

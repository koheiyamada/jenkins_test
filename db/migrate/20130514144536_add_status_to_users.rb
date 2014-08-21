class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, :default => 'new'
    add_index :users, :status
  end
end

class AddPcSpecColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :adsl, :boolean, :default => false
    add_column :users, :upload_speed, :float
    add_column :users, :download_speed, :float
    add_column :users, :os_id, :integer
    add_column :users, :windows_experience_index_score, :float
  end
end

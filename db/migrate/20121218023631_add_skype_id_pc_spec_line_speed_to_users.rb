class AddSkypeIdPcSpecLineSpeedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :skype_id, :string
    add_column :users, :pc_spec, :string
    add_column :users, :line_speed, :string
  end
end

class AddEmailAddressesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_email, :string
    add_column :users, :pc_email, :string
    add_column :users, :gmail, :string
  end
end

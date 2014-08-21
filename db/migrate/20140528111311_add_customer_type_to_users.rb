class AddCustomerTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_type, :string
  end
end

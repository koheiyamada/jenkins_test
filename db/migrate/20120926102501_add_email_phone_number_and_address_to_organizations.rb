class AddEmailPhoneNumberAndAddressToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :email, :string
    add_column :organizations, :phone_number, :string
    add_column :organizations, :address_id, :integer
    add_index :organizations, :address_id
  end
end

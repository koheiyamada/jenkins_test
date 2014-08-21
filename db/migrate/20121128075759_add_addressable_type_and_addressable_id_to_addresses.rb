class AddAddressableTypeAndAddressableIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :addressable_type, :string
    add_column :addresses, :addressable_id, :integer
    add_column :addresses, :line1, :string
    add_column :addresses, :line2, :string
    add_column :addresses, :city, :string
    add_column :addresses, :state, :string

    add_index :addresses, :addressable_type
    add_index :addresses, :addressable_id
  end
end

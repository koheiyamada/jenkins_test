class AddPostalCode1AndPostalCode2ToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :postal_code1, :string
    add_column :addresses, :postal_code2, :string
  end
end

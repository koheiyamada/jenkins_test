class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :postal_code
      t.string :address

      t.timestamps
    end
  end
end

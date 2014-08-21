class CreatePostalCodes < ActiveRecord::Migration
  def change
    create_table :postal_codes do |t|
      t.string :postal_code
      t.string :prefecture
      t.string :city
      t.string :town
      t.string :area_code

      t.timestamps
    end

    add_index :postal_codes, :postal_code
  end
end

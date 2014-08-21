class AddZipCodeIdAndAreaCodeIdToPostalCodes < ActiveRecord::Migration
  def change
    add_column :postal_codes, :zip_code_id, :integer
    add_column :postal_codes, :area_code_id, :integer
    add_index :postal_codes, :zip_code_id
    add_index :postal_codes, :area_code_id
  end
end

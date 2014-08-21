class RemoveColumnsFromPostalCodes < ActiveRecord::Migration
  def up
    remove_column :postal_codes, :postal_code
    remove_column :postal_codes, :area_code
  end

  def down
    add_column :postal_codes, :postal_code, :string
    add_column :postal_codes, :area_code, :string
  end
end

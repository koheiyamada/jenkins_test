class AddAreaCodeToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :area_code, :string
    add_index :organizations, :area_code
  end
end

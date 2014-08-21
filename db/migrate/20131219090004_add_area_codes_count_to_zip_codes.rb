class AddAreaCodesCountToZipCodes < ActiveRecord::Migration
  def change
    add_column :zip_codes, :area_codes_count, :integer, null: false, default: 0
  end
end

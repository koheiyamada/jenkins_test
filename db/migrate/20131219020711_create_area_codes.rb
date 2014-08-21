class CreateAreaCodes < ActiveRecord::Migration
  def change
    create_table :area_codes do |t|
      t.string :code, null: false
    end

    add_index :area_codes, :code
  end
end

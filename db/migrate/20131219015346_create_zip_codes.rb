class CreateZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :code, null: false
    end

    add_index :zip_codes, :code
  end
end

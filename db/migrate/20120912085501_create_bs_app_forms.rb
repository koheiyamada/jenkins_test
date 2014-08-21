class CreateBsAppForms < ActiveRecord::Migration
  def change
    create_table :bs_app_forms do |t|
      t.references :bs_user
      t.string :first_name
      t.string :last_name
      t.string :corporate_name
      t.references :address
      t.string :phone_number
      t.string :email
      t.string :skype_id
      t.string :pc_spec
      t.string :line_speed
      t.date :representative_birthday
      t.string :representative_sex, :default => "male"
      t.text :reason_for_applying
      t.boolean :confirmed, :default => false

      t.timestamps
    end
    add_index :bs_app_forms, :address_id
    add_index :bs_app_forms, :bs_user_id
  end
end

class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.references :user
      t.string :pc_mail
      t.string :phone_mail
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :pc_spec
      t.string :line_speed
      t.references :address
      t.string :reference_user_name
      t.string :confirmation_token

      t.timestamps
    end
    add_index :user_infos, :address_id
    add_index :user_infos, :user_id
  end
end

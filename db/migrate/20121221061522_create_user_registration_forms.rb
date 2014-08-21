class CreateUserRegistrationForms < ActiveRecord::Migration
  def change
    create_table :user_registration_forms do |t|
      t.references :user
      t.string :type
      t.string :email
      t.boolean :adsl, :default => false
      t.string :confirmation_token

      t.timestamps
    end
    add_index :user_registration_forms, :user_id
    add_index :user_registration_forms, :type
  end
end

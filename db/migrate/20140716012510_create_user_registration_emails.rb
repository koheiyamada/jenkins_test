class CreateUserRegistrationEmails < ActiveRecord::Migration
  def change
    create_table :user_registration_emails do |t|

      t.integer :user_id,  null: false
      t.string  :email,  null: false
      t.string  :token,  null: false

      t.timestamps
    end
  end
end

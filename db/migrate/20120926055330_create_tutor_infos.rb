class CreateTutorInfos < ActiveRecord::Migration
  def change
    create_table :tutor_infos do |t|
      t.references :tutor
      t.string :first_name
      t.string :last_name
      t.string :pc_mail
      t.string :phone_mail
      t.string :phone_number
      t.string :skype_id
      t.string :photo
      t.string :nickname
      t.references :current_address
      t.references :hometown_address
      t.string :college
      t.string :department
      t.integer :year_of_admission
      t.integer :year_of_graduation
      t.string :birth_place
      t.string :high_school
      t.string :activities
      t.string :teaching_experience
      t.string :teaching_results
      t.string :free_description

      t.boolean :confirmed, :default => false
      t.string :status, :default => "new"

      t.timestamps
    end
    add_index :tutor_infos, :tutor_id
    add_index :tutor_infos, :current_address_id
    add_index :tutor_infos, :hometown_address_id
    add_index :tutor_infos, :status
  end
end

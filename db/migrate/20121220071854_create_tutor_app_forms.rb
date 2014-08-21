class CreateTutorAppForms < ActiveRecord::Migration
  def change
    create_table :tutor_app_forms do |t|
      t.references :tutor
      t.string :first_name
      t.string :last_name
      t.string :pc_mail
      t.string :phone_mail
      t.string :phone_number
      t.string :skype_id
      t.string :photo
      t.string :nickname
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
      t.boolean :do_volunteer_work, :default => false
      t.boolean :undertake_group_lesson, :default => false
      t.string :job_history

      t.timestamps
    end
    add_index :tutor_app_forms, :tutor_id
  end
end

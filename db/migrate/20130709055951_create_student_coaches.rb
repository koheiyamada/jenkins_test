class CreateStudentCoaches < ActiveRecord::Migration
  def change
    create_table :student_coaches do |t|
      t.references :coach
      t.references :student

      t.timestamps
    end
    add_index :student_coaches, :coach_id
    add_index :student_coaches, :student_id
  end
end

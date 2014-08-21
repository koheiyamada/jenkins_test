class CreateLessonCharges < ActiveRecord::Migration
  def change
    create_table :lesson_charges do |t|
      t.references :lesson_student
      t.integer :fee

      t.timestamps
    end
    add_index :lesson_charges, :lesson_student_id
  end
end

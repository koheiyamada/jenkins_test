class CreateLessonTutorWages < ActiveRecord::Migration
  def change
    create_table :lesson_tutor_wages do |t|
      t.references :lesson
      t.integer :wage
      t.boolean :includes_group_lesson_premium, :default => false

      t.timestamps
    end
    add_index :lesson_tutor_wages, :lesson_id
  end
end

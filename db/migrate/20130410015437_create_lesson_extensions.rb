class CreateLessonExtensions < ActiveRecord::Migration
  def change
    create_table :lesson_extensions do |t|
      t.references :lesson
      t.integer :duration, :default => 30

      t.timestamps
    end
    add_index :lesson_extensions, :lesson_id
  end
end

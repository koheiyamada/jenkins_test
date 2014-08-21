class CreateLessonExtendabilities < ActiveRecord::Migration
  def change
    create_table :lesson_extendabilities do |t|
      t.references :lesson
      t.boolean :extendable, :default => false
      t.string :reason

      t.timestamps
    end
    add_index :lesson_extendabilities, :lesson_id
  end
end

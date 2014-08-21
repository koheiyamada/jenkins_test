class CreateLessonMaterials < ActiveRecord::Migration
  def change
    create_table :lesson_materials do |t|
      t.integer :user_id
      t.integer :lesson_id
      t.string  :material

      t.timestamps
    end

    add_index :lesson_materials, :user_id
    add_index :lesson_materials, :lesson_id
  end
end

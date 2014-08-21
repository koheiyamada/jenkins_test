class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :type
      t.references :subject
      t.references :tutor
      t.datetime :start_time
      t.datetime :end_time
      t.integer :units, :default => 1

      t.timestamps
    end
    add_index :lessons, :subject_id
    add_index :lessons, :tutor_id
    add_index :lessons, :type
  end
end

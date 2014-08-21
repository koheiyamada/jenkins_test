class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.references :creator
      t.references :grade
      t.references :subject
      t.date :month
      t.string :file

      t.timestamps
    end
    add_index :exams, :creator_id
    add_index :exams, :grade_id
    add_index :exams, :subject_id
  end
end

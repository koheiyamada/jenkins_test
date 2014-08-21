class CreateStudentInfos < ActiveRecord::Migration
  def change
    create_table :student_infos do |t|
      t.references :student
      t.references :grade
      t.string :academic_results
      t.boolean :use_textbooks
      t.boolean :teach_by_using_textbooks

      t.timestamps
    end
    add_index :student_infos, :student_id
    add_index :student_infos, :grade_id
  end
end

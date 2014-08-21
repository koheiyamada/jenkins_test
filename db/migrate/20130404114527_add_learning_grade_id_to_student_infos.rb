class AddLearningGradeIdToStudentInfos < ActiveRecord::Migration
  def change
    add_column :student_infos, :learning_grade_id, :integer
  end
end

class PopulateGradeGroupsAndSubjects < ActiveRecord::Migration
  def up
    require Rails.root.join 'script/grades/populate_grade_groups'
    require Rails.root.join 'script/grades/populate_grade_subjects'
  end

  def down
  end
end

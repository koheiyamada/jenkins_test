class ResetTeachingSubjects < ActiveRecord::Migration
  def up
    require Rails.root.join 'script/subjects/reset_teaching_subjects'
  end

  def down
  end
end

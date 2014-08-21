class PopulateSubjectLevels < ActiveRecord::Migration
  def up
    require Rails.root.join 'script/subjects/populate_subject_levels'
  end

  def down
  end
end

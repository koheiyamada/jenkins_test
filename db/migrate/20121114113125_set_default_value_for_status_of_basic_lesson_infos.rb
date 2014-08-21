class SetDefaultValueForStatusOfBasicLessonInfos < ActiveRecord::Migration
  def up
    change_column :basic_lesson_infos, :status, :string, :default => "new", :null => false
  end

  def down
    change_column :basic_lesson_infos, :status, :string
  end
end

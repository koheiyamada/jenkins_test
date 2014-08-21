class AddTypeToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :type, :string
  end
end

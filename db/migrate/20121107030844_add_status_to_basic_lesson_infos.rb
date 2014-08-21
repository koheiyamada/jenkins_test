class AddStatusToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :status, :string
  end
end

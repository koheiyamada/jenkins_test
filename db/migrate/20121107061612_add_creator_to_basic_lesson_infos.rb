class AddCreatorToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :creator_id, :integer
    add_index :basic_lesson_infos, :creator_id
  end
end

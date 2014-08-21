class AddAutomaticExtensionToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :auto_extension, :boolean, :default => true
  end
end

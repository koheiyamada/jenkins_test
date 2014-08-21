class AddJournalizedToLessonTutorWages < ActiveRecord::Migration
  def change
    add_column :lesson_tutor_wages, :journalized, :boolean, :default => false
  end
end

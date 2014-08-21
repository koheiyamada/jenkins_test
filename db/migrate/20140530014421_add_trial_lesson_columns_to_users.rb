class AddTrialLessonColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trial_lesson_taken, :integer, default: 0
    add_column :users, :trial_lesson_limit_number, :integer
    add_column :users, :trial_lesson_expiration_date, :integer
  end
end

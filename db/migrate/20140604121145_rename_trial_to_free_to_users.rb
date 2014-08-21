class RenameTrialToFreeToUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :trial_lesson_taken
    remove_column :users, :trial_lesson_limit_number
    remove_column :users, :trial_lesson_expiration_date
    add_column :users, :free_lesson_taken, :integer, default: 0
    add_column :users, :free_lesson_limit_number, :integer
    add_column :users, :free_lesson_expiration_date, :integer
  end
end
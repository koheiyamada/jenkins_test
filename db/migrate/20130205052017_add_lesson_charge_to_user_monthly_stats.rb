class AddLessonChargeToUserMonthlyStats < ActiveRecord::Migration
  def change
    add_column :user_monthly_stats, :lesson_charge, :integer, :default => 0
  end
end

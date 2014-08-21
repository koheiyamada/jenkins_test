class CreateUserMonthlyStats < ActiveRecord::Migration
  def change
    create_table :user_monthly_stats do |t|
      t.references :user
      t.integer :year
      t.integer :month
      t.integer :optional_lesson_cancellation_count, :default => 0
      t.integer :basic_lesson_cancellation_count, :default => 0

      t.timestamps
    end
    add_index :user_monthly_stats, :user_id
    add_index :user_monthly_stats, [:user_id, :year, :month], :unique => true
  end
end

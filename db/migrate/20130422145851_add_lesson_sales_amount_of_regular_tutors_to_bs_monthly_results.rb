class AddLessonSalesAmountOfRegularTutorsToBsMonthlyResults < ActiveRecord::Migration
  def change
    add_column :bs_monthly_results, :lesson_sales_of_regular_tutors, :integer, :default => 0
    add_column :bs_monthly_results, :bs_share_of_lesson_sales, :integer, :default => 0
  end
end

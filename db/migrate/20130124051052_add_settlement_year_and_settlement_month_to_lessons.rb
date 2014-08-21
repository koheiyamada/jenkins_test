class AddSettlementYearAndSettlementMonthToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :settlement_year, :integer
    add_column :lessons, :settlement_month, :integer

    update
  end

  def update
    Lesson.all.each do |lesson|
      if lesson.payment_month
        lesson.settlement_year = lesson.payment_month.year
        lesson.settlement_month = lesson.payment_month.month
        lesson.save
      end
    end
  end
end

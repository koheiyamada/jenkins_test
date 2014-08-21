class CalculateNextMonthlyStatements < ScheduledJob

  def self.perform
    d = Date.today.next_month
    MonthlyStatement.calculate_for_all(d.year, d.month)
  end

end
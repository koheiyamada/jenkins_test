class CalculateMonthlyStatements < ScheduledJob

  def self.perform
    d = Date.today
    MonthlyStatement.calculate_for_all(d.year, d.month)
  end

end
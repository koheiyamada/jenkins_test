class MonthlyCalculation < ScheduledJob

  def self.perform
    d = Date.today
    MonthlyStatement.calculate_for_all_and_charge_the_payment_of_all_students(d.year, d.month)
  end

end
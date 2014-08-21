class TutorMonthlyIncomesController < ApplicationController
  layout 'with_sidebar'

  def this_month
    today = Date.today
    @year = today.year
    @month = today.month
    @tutor_monthly_income = @tutor.monthly_incomes.of_month(@year, @month)
  end

end

class Tu::IncomeOfThisMonthController < TutorMonthlyIncomesController
  tutor_only

  prepend_before_filter do
    @tutor = current_user
    @this_month = Account::JournalEntry.settlement_month_of_day Date.today
    @year = @this_month.year
    @month = @this_month.month
  end

  def show
    @tutor_monthly_income = @tutor.monthly_incomes.of_month(@year, @month)
    respond_to do |format|
      format.html
      format.json{ render json: @tutor_monthly_income }
    end
  end

  def calculate
    @tutor_monthly_income = @tutor.monthly_incomes.of_month(@year, @month)
    @tutor_monthly_income.delay.calculate
    render json: @tutor_monthly_income
  end

  def update
    #@tutor_monthly_income = @tutor.monthly_incomes.of_month(@year, @month)
    #@tutor_monthly_income.delay.calculate
    #render json: @tutor_monthly_income
  end
end

class Hq::MonthlyStatementsController < MonthlyStatementsController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting

  def yucho
    @monthly_statement = subject.monthly_statements.find(params[:id])
    @year = @monthly_statement.year
    @month = @monthly_statement.month
  end

  def calculate_all
    @monthly_statement = subject.monthly_statements.find(params[:id])
    @monthly_statement_calculation = MonthlyStatementCalculation.new(year: @monthly_statement.year, month: @monthly_statement.month)
    if @monthly_statement_calculation.save
      @monthly_statement_calculation.delay.execute
    end
  end

  private

    def subject
      Headquarter.instance
    end
end

class Bs::MonthlyStatementsController < MonthlyStatementsController
  bs_user_only

  def bill
    @lesson_charges = subject.lesson_charges.of_settlement_month(@monthly_statement.year, @monthly_statement.month)
    super
  end

  def payment
    @bs = subject
    @lesson_charges = subject.lesson_charges.of_settlement_month(@monthly_statement.year, @monthly_statement.month)
    super
  end

  private

  def subject
    current_user.organization
  end

  def demandee
    current_user
  end
end

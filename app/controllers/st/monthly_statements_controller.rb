class St::MonthlyStatementsController < MonthlyStatementsController
  include StudentAccessControl
  student_only

  before_filter do
    @student = current_user
  end

  def bill
    @lessons = subject.lessons.charged_on(@monthly_statement.year, @monthly_statement.month)
    super
  end
end

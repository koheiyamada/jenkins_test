class Pa::Students::MonthlyStatementsController < MonthlyStatementsController
  parent_only

  def bill
    @lessons = subject.lessons.charged_on(@monthly_statement.year, @monthly_statement.month)
    super
  end

  private

    def subject
      @student ||= current_user.students.find(params[:student_id])
    end

    def demandee
      current_user
    end
end

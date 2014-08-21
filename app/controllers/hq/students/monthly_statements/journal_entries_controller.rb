class Hq::Students::MonthlyStatements::JournalEntriesController < Hq::JournalEntriesController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting

  before_filter do
    @student = Student.find(params[:student_id])
    @monthly_statement = @student.monthly_statements.find(params[:monthly_statement_id])
  end

  private

    def subject
      @monthly_statement
    end
end

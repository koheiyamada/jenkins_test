class Hq::Tutors::MonthlyStatements::JournalEntriesController < Hq::JournalEntriesController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting

  before_filter do
    @tutor = Tutor.find(params[:tutor_id])
    @monthly_statement = @tutor.monthly_statements.find(params[:monthly_statement_id])
  end

  private

    def subject
      @monthly_statement
    end
end

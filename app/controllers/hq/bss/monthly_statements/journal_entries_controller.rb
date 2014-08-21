class Hq::Bss::MonthlyStatements::JournalEntriesController < Hq::JournalEntriesController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting

  before_filter do
    @bs = Bs.find(params[:bs_id])
    @monthly_statement = @bs.monthly_statements.find(params[:monthly_statement_id])
  end

  private

    def subject
      @monthly_statement
    end
end

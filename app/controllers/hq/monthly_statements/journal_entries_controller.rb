class Hq::MonthlyStatements::JournalEntriesController < JournalEntriesController
  hq_user_only
  before_filter :prepare_monthly_statement

  def index
    @journal_entries = @monthly_statement.journal_entries.for_list.order('created_at DESC').page(params[:page])
  end

  private

  def subject
    current_user.organization
  end

  def prepare_monthly_statement
    @monthly_statement = MonthlyStatement.find(params[:monthly_statement_id])
  end
end

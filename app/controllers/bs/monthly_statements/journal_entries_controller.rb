class Bs::MonthlyStatements::JournalEntriesController < JournalEntriesController
  bs_user_only
  before_filter :prepare_monthly_statement

  def index
    @journal_entries = @monthly_statement.journal_entries.for_list.order('created_at DESC').page(params[:page])
  end

  private

  def subject
    current_user.organization
  end
end

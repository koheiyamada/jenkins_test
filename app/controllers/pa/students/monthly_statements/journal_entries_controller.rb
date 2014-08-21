class Pa::Students::MonthlyStatements::JournalEntriesController < JournalEntriesController
  parent_only

  before_filter do
    @parent = current_user
    @student = current_user.students.find(params[:student_id])
    @monthly_statement = @student.monthly_statements.find(params[:monthly_statement_id])
  end

  def index
    @journal_entries = @monthly_statement.journal_entries.for_list.page(params[:page])
  end

  def show
    @journal_entry = @monthly_statement.journal_entries.find(params[:id])
  end

end

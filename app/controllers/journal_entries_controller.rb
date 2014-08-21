class JournalEntriesController < ApplicationController
  layout 'with_sidebar'

  def index
    @journal_entries = subject.journal_entries.order("created_at DESC").page(params[:page])
  end

  def month
    month = Date.new(params[:year].to_i, params[:month].to_i)
    @journal_entries = subject.journal_entries.of_month(month).page(params[:page])
    render action:"index"
  end

  def show
    @journal_entry = subject.journal_entries.find(params[:id])
  end

  private

    def subject
      current_user
    end

    def prepare_monthly_statement
      if params[:monthly_statement_id]
        @monthly_statement = MonthlyStatement.find(params[:monthly_statement_id])
      end
    end
end

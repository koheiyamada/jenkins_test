class MonthlyStatements::AdjustingEntriesController < ApplicationController
  layout 'with_sidebar'
  before_filter :prepare_monthly_statement

  def index
    @adjusting_entries = @monthly_statement.adjusting_entries
  end

  def create
    @adjusting_entry = Account::AdjustingEntry.new(params[:account_adjusting_entry]) do |entry|
      entry.owner = @monthly_statement.owner
      entry.year = @monthly_statement.year
      entry.month = @monthly_statement.month
    end
    if @adjusting_entry.save
      @monthly_statement.calculate
      redirect_to action:'index'
    else
      logger.error @adjusting_entry.errors.full_messages.join(',')
      redirect_to({action:'index'}, alert:t('common.error'))
    end
  end

  def destroy
    @adjusting_entry = Account::AdjustingEntry.find(params[:id])
    @adjusting_entry.destroy
    @monthly_statement.calculate
    redirect_to action:'index'
  end

  private

    def prepare_monthly_statement
      @monthly_statement = MonthlyStatement.find(params[:monthly_statement_id])
    end
end

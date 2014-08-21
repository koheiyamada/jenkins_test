class LedgersController < ApplicationController
  layout 'with_sidebar'

  def index
    @ledgers = ledgerable.ledgers.order("created_at DESC").page(params[:page])
  end

  def year
    @year = params[:year].to_i
    @ledgers = ledgerable.ledgers.of_year(@year).order("created_at DESC").page(params[:page])
    @ledger_strips = @ledgers.group_by{|ledger| ledger.month.month}
  end

  def month
    @year = params[:year].to_i
    @month = params[:month].to_i
    @ledger = ledgerable.ledger_of_month(@year, @month)
  end

  # POST ledgers/:year/:month/calculate
  def calculate
    @year = params[:year].to_i
    @month = params[:month].to_i
    @ledger = ledgerable.ledger_of_month(@year, @month)
    if @ledger.calculate
    else
    end
  end

  def show
    @ledger = ledgerable.ledgers.find(params[:id])
  end

  private

  def ledgerable
    current_user
  end
end

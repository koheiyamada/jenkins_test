class Hq::MonthlyStatementCalculationsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    @monthly_statement_calculations = MonthlyStatementCalculation.order('created_at DESC').page(params[:page])
  end

  def show
    @monthly_statement_calculation = MonthlyStatementCalculation.find(params[:id])
    respond_to do |format|
      format.json{ render json: @monthly_statement_calculation }
    end
  end
end

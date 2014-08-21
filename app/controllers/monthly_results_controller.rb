class MonthlyResultsController < ApplicationController
  layout 'with_sidebar'

  def index
    @year = (params[:year] || Date.today.year).to_i
    @monthly_results = subject.monthly_results.of_year(@year)
  end

  def show
    @monthly_result = subject.monthly_results.find(params[:id])
  end

  def calculate
    @monthly_result = subject.monthly_results.find(params[:id])
    if @monthly_result.update_deals
      redirect_to action:"show"
    else
      redirect_to({action:"show"}, alert:"Error")
    end
  end

  private

  def subject
    current_user.organization
  end
end

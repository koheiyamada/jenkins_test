class MonthlyUsagesController < ApplicationController
  layout 'with_sidebar'

  def index
    @year = (params[:year] || Date.today.year).to_i
    @month = (params[:month] || Date.today.month).to_i
    redirect_to action: :year_month, year:@year, month:@month
  end

  def show
    @monthly_stat = subject.monthly_stats.find(params[:id])
    redirect_to action: :year_month, year:@monthly_stat.year, month:@monthly_stat.month
  end

  def year_month
    @year = params[:year].to_i
    @month = params[:month].to_i
    @monthly_stat = subject.monthly_stats_for(@year, @month)
  end

  def calculate
    @monthly_stat = subject.monthly_stats.find(params[:id])
    @monthly_stat.update_usage
    redirect_to action: :show
  end

  private

    def subject
      current_user
    end
end

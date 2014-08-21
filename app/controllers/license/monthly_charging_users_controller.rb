class License::MonthlyChargingUsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_or_system_admin_only

  layout 'with_sidebar'

  def index
    @year = (params[:year] || Date.today.year).to_i
    @monthly_count = MonthlyChargingUser.where(year: @year).group('month').count
  end

  def month
    @year = params[:year].to_i
    @month = params[:month].to_i
    @monthly_charging_users = MonthlyChargingUser.of_month(@year, @month).page(params[:page])
  end

  def calculate
    @year = params[:year].to_i
    @month = params[:month].to_i
    @job = MonthlyChargingUser.calculate(@year, @month)
    respond_to do |format|
      format.json do
        render json: @job
      end
    end
  end

  def job
    if params[:job_id]
      @job = Delayed::Job.find_by_id(params[:job_id])
      respond_to do |format|
        format.json do
          if @job
            render json: {status: 'running', job: @job}
          else
            render json: {status: 'done'}
          end
        end
      end
    else
      render json: {}, status: :not_found
    end
  end

  private

    def admin_or_system_admin_only

    end
end

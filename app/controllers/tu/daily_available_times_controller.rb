class Tu::DailyAvailableTimesController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @daily_available_times = current_user.daily_available_times.from_today.page(params[:page])
  end

  def dates
    @dates = current_user.daily_available_times.from_today.until(3.months.from_now).flat_map(&:to_dates).uniq
    respond_to do |format|
      format.json do
        render json: @dates.map{|d| {date: d}}
      end
    end
  end

  def month
    @date = Date.new(params[:year].to_i, params[:month].to_i)
    @daily_available_times = current_user.daily_available_times.of_month(@date)
    respond_to do |format|
      format.html
      format.json{render json: @daily_available_times}
    end
   end

  def date
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    @daily_available_times = current_user.daily_available_times.of_day(@date)
    respond_to do |format|
      format.html
      format.json{render json: @daily_available_times}
    end
  end

  def new

  end

  def create
    attrs = convert_attributes(params[:daily_available_time])
    @daily_available_time = current_user.daily_available_times.build(attrs)
    respond_to do |format|
      format.json do
        if @daily_available_time.save
          render json: {id: @daily_available_time.id}
        else
          render json: {error_messages: @daily_available_time.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  # GET /tu/daily_available_times/edit
  def edit

  end

  # POST /tu/daily_available_times/update
  def update_all
    respond_to do |format|
      format.json do
        s = TutorDailyAvailableTimeService.new(current_user)
        if s.bulk_update_and_notify(params)
          render json: {success: 1}
        else
          render json: {success: 0, error_messages: s.error_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @daily_available_time = current_user.daily_available_times.find(params[:id])
    @daily_available_time.destroy()
    render json: {success: 1}
  rescue Exception => e
    render json: {success: 0, error_messages: [e.message]}
  end

  private

    def convert_attributes(attributes)
      {
        start_at: Time.at(attributes[:start_at] / 1000),
        end_at: Time.at(attributes[:end_at] / 1000)
      }
    end
end

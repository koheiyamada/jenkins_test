class TutorDailyAvailableTimesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    @tutor = Tutor.find(params[:tutor_id])
  end

  attr_reader :tutor

  def index
    @daily_available_times = tutor.daily_available_times.for_calendar
  end

  def date
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    @daily_available_times = tutor.daily_available_times.of_day(@date)
    respond_to do |format|
      format.html
      format.json{render json: @daily_available_times}
    end
  end
end

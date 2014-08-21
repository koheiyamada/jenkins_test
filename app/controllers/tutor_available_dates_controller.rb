class TutorAvailableDatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_tutor
  attr_reader :tutor

  def index
    @dates = tutor.daily_available_times.for_calendar.flat_map(&:to_dates).uniq
    respond_to do |format|
      format.json do
        render json: @dates.map{|d| {date: d}}
      end
    end
  end
end

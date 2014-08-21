class Tu::Settings::WeekdaySchedulesController < ApplicationController
  tutor_only
  layout 'with_sidebar'
  after_filter :tutor_weekday_schedules_changed, :only => [:create, :destroy]

  def index
    @weekday_schedules = current_user.weekday_schedules.sort
  end

  def new
    @weekday_schedule = WeekdaySchedule.new
    render layout: nil if request.xhr?
  end

  def create
    @weekday_schedule = WeekdaySchedule.new(params[:weekday_schedule])
    @weekday_schedule.tutor = current_user
    respond_to do |format|
      format.html do
        if @weekday_schedule.save
          redirect_to action: :index
        else
          logger.error @weekday_schedule.errors.full_messages
          @weekday_schedules = current_user.weekday_schedules.sort
          render :index
        end
      end
      format.js do
        @weekday_schedule.save
      end
    end
  end

  def destroy
    @weekday_schedule = current_user.weekday_schedules.find_by_id(params[:id])
    if @weekday_schedule
      @weekday_schedule.destroy
    end
    redirect_to action:"index"
  end

  private

    def tutor_weekday_schedules_changed
      current_user.on_weekday_schedules_changed
    end
end

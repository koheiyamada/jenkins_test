class Tu::AvailableTimesController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @available_times = current_user.available_times
    if @available_times.empty? && current_user.weekday_schedules.present?
      current_user.update_available_times
      @available_times = AvailableTime.of_tutor(current_user)
    end
    @available_times_grouped_by_day = @available_times.group_by{|t| t.from.to_date}
  end
end

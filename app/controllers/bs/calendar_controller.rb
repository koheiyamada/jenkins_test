class Bs::CalendarController < ApplicationController
  bs_user_only
  layout "plain"

  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Lesson.event_strips_for_month(@shown_month,
                                                  :include => :students,
                                                  :conditions => {
                                                    :users => {:organization_id => current_user.organization_id},
                                                    :show_on_calendar => true
                                                  })
    render layout:nil if request.xhr?
  end
end

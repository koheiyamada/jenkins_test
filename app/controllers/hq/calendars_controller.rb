class Hq::CalendarsController < ApplicationController
  hq_user_only
  layout "plain"

  def lessons
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Lesson.event_strips_for_month(@shown_month, :conditions => {show_on_calendar:true})
  end

end

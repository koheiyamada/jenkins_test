class Bs::Tutors::CalendarsController < ApplicationController
  bs_user_only
  layout "plain"

  def lessons
    @tutor = current_user.tutors.find(params[:tutor_id])

    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Lesson.event_strips_for_month(@shown_month,
                                                  :conditions => {tutor_id:@tutor.id, show_on_calendar:true})
  end

  def available_times
    @tutor = current_user.tutors.find(params[:tutor_id])

    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = AvailableTime.event_strips_for_month(@shown_month,
                                                  :conditions => {tutor_id:@tutor.id})
  end
end

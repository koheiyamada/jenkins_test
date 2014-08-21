class Pa::StudentCalendarController < ApplicationController
  include ParentAccessControl
  parent_only
  layout "plain"
  before_filter :prepare_student

  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Lesson.event_strips_for_month(@shown_month,
                                                  :include => :lesson_students,
                                                  :conditions => {:lesson_students => {:student_id => @student.id}})
    render layout:nil if request.xhr?
  end
end

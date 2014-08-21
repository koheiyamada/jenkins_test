class Hq::LessonsController < LessonsController
  include HqUserAccessControl
  hq_user_only
  access_control

  def calendar
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Lesson.event_strips_for_month(@shown_month, :conditions => {show_on_calendar:true})
    render layout:nil if request.xhr?
  end

  def new
    
  end

  def accounting
    @lesson = Lesson.find(params[:id])
  end
end

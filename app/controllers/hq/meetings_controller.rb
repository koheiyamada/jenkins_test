class Hq::MeetingsController < MeetingsController
  include HqUserAccessControl
  hq_user_only
  access_control :meeting
  layout 'with_sidebar'

  def index
    @meetings = Meeting.today_or_later.for_list.order('datetime DESC').page(params[:page])
  end

  def scheduling
    @meetings = Meeting.scheduling.for_list.order('created_at DESC').page(params[:page])
  end

  def done
    @meetings = Meeting.done.for_list.order('datetime DESC').page(params[:page])
  end

  def show
    @meeting = Meeting.find params[:id]
    render action: "show_#{@meeting.status}"
  end
end

class Pa::MeetingsController < MeetingsController
  include ParentAccessControl
  parent_only

  def index
    @meetings = current_user.meetings.today_or_later.order(:datetime).page(params[:page])
  end

  def show
    @meeting = current_user.meetings.find(params[:id])
    @member = @meeting.member(current_user)
    render action: "show_#{@meeting.status}"
  end
end

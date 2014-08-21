class Tu::MeetingSchedulesController < Meetings::SchedulesController
  tutor_only

  # POST meetings/:meeting_id/schedules/:id/select
  def select
    @meeting_schedule = @meeting.schedules.find(params[:id])
    member = @meeting.member(current_user).select_schedule(@meeting_schedule)
    if member.valid?
      redirect_to redirect_path_on_selected
    else
      render action: 'show'
    end
  end

  private

    def redirect_path_on_selected
      tu_meeting_path(@meeting)
    end

    def prepare_meeting
      @meeting = current_user.meetings.find(params[:meeting_id])
    end

end

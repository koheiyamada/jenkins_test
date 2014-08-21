class Pa::Meetings::SchedulesController < Meetings::SchedulesController
  parent_only

  def select
    @schedule = @meeting.schedules.find(params[:id])
    member = @meeting.member(current_user).select_schedule(@schedule)
    if member.valid?
      redirect_to redirect_path_on_selected
    else
      render action: 'show'
    end
  end

  private

    def redirect_path_on_selected
      pa_meeting_path(@meeting)
    end

    def prepare_meeting
      @meeting = current_user.meetings.find(params[:meeting_id])
    end
end

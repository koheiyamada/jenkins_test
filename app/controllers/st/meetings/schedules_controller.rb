class St::Meetings::SchedulesController < Meetings::SchedulesController
  student_only

  def select
    @schedule = @meeting.schedules.find(params[:id])
    member = @meeting.member(current_user).select_schedule(@schedule)
    if member.valid?
      redirect_to st_meeting_path(@meeting)
    else
      render action: 'show'
    end
  end

  def select_other
    member = @meeting.member(current_user)
    if member.select_other_schedule
      redirect_to st_meeting_path(@meeting)
    else
      redirect_to st_meeting_path(@meeting)
    end
  end

  private

    def prepare_meeting
      @meeting = current_user.meetings.find(params[:meeting_id])
    end

end

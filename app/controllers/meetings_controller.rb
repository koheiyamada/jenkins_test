class MeetingsController < ApplicationController
  layout 'with_sidebar'

  def index
    @meetings = current_user.meetings.today_or_later.order('datetime DESC').page(params[:page])
  end

  def scheduling
    @meetings = current_user.meetings.scheduling.order('created_at DESC').page(params[:page])
  end

  def done
    @meetings = current_user.meetings.done.order('datetime DESC').page(params[:page])
  end

  def new
    @meeting = Meeting.new
  end

  def create
    if params[:type] == 'special_tutor_meeting'
      create_special_tutor_meeting
    else
      current_user.meetings.registering.destroy_all
      @meeting = Meeting.new(creator: current_user) do |meeting|
        meeting.members << current_user
      end
      if @meeting.save
        redirect_to forms_path
      else
        render action: 'new'
      end
    end
  end

  def show
    @meeting = Meeting.find params[:id]
    @member = @meeting.member(current_user)
    render action: "show_#{@meeting.status}"
  end

  def room
    @meeting = current_user.meetings.find(params[:id])
    if @meeting.today?
      @meeting.join(current_user)
      render layout: 'meeting_room'
    else
      redirect_to action: :show
    end
  end

  # POST meetings/:id/done
  def close
    @meeting = current_user.meetings.find(params[:id])
    @meeting.close
    if @meeting.valid?
      redirect_to path_after_close
    else
      render action: 'error'
    end
  end

  private

    def create_special_tutor_meeting
      current_user.meetings.registering.destroy_all
      @meeting = SpecialTutorMeeting.new(creator: current_user) do |meeting|
        meeting.members << current_user
      end
      if @meeting.save
        redirect_to url_for(action: 'show', id: @meeting) + '/forms2'
      else
        render action: 'new'
      end
    end

    def forms_path
      url_for(action: 'show', id: @meeting) + '/forms'
    end

    def path_after_close
      url_for(action: 'show', id: @meeting) + '/report/new'
    end
end

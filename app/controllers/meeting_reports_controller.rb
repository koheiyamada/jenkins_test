class MeetingReportsController < ApplicationController
  layout 'with_sidebar'
  before_filter :prepare_meeting
  before_filter :check_meeting_member, only: [:new, :create]
  before_filter :ensure_meeting_closed, only: :new

  def show
    @meeting_report = @meeting.meeting_report
    @student = @meeting.student_member
    if @student
      @parent = @student.parent
    end
  end

  def new
    @meeting_report = @meeting.build_meeting_report
    @meeting_report.text = render_to_string partial: 'text_template'
    @student = @meeting.student_member
  end

  def create
    @meeting_report = @meeting.build_meeting_report(params[:meeting_report]) do |meeting_report|
      meeting_report.author = current_user
    end
    if @meeting_report.save
      redirect_to path_after_create
    else
      render action: 'new'
    end
  end

  def edit
    @meeting_report = @meeting.meeting_report
    @student = @meeting.student_member
    if @student
      @parent = @student.parent
    end
  end

  def update
    @meeting_report = @meeting.meeting_report
    if @meeting_report.update_attributes(params[:meeting_report])
      redirect_to action: :show
    else
      render :edit
    end
  end

  private

    def path_after_create
      url_for(action: 'show')
    end

    def prepare_meeting
      @meeting = current_user.meetings.find(params[:meeting_id])
    end

    def check_meeting_member
      unless @meeting.member? current_user
        render template: 'errors/error_403', status: :forbidden
      end
    end

    def ensure_meeting_closed
      unless @meeting.done?
        @meeting.close
        logger.info "MEETING CLOSED\tid:#{@meeting.id}"
      end
    end
end

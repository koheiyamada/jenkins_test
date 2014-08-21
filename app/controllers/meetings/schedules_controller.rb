# coding:utf-8
class Meetings::SchedulesController < ApplicationController
  layout 'with_sidebar'

  before_filter :prepare_meeting

  def index
    @meeting_schedules = @meeting.schedules
  end

  def show
    @meeting_schedule = @meeting.schedules.find(params[:id])
  end

  # POST meetings/:meeting_id/schedules/:id/select
  # 面談の開催日時を決定する。
  # 本部・BS向けのアクションなので、受講者や保護者がこれを呼ばないように。
  def select
    @meeting_schedule = @meeting.schedules.find(params[:id])
    @meeting.schedule = @meeting_schedule
    if @meeting.save
      redirect_to redirect_path_on_selected
    else
      render action: 'show'
    end
  end

  def select_other
    member = @meeting.member(current_user)
    if member.select_other_schedule
      redirect_to redirect_path_on_selected
    else
      redirect_to redirect_path_on_selected
    end
  end

  def edit
    @meeting_schedule = @meeting.schedules.find(params[:id])
    if @meeting_schedule.datetime < Time.current
      @meeting_schedule.datetime = Time.current
    end
  end

  def update
    @meeting_schedule = @meeting.schedules.find(params[:id])
    date = Date.parse(params[:date])
    @meeting_schedule.datetime = Time.new(date.year, date.month, date.day, params[:time][:hour], params[:time][:minute])
    if @meeting_schedule.save
      redirect_to redirect_path_on_updated
    else
      render :edit
    end
  end

  def destroy
    @meeting_schedule = @meeting.schedules.destroy(params[:id])
    redirect_to redirect_path_on_deleted
  end

  private

    def redirect_path_on_selected
      root_path
    end

    def redirect_path_on_updated
      {action: 'index'}
    end

    def redirect_path_on_deleted
      {action: 'index'}
    end

    def prepare_meeting
      @meeting = current_user.meetings.find(params[:meeting_id])
    end

end

class MeetingFormsController < ApplicationController
  layout 'with_sidebar'
  include Wicked::Wizard

  steps :member_type, :student, :parent, :schedule, :confirmation

  def show
    @meeting = Meeting.find(params[:meeting_id])
    send step
  end

  def update
    Meeting.transaction do
      @meeting = Meeting.find(params[:meeting_id])
      send step
    end
  end

  def member_type
    if request.get?
      render_wizard
    else

    end
  end

  def student
    @search_flg = false
    if request.get?
      if @meeting.have_enough_members?
        redirect_to wizard_path(:schedule)
      else
        @students = students
        render_wizard
      end
    else
      @meeting.members.delete(@meeting.members.of_type(Student))
      @meeting.members << current_user.students.find(params[:student_id])
      render_wizard @meeting
    end
  end

  def parent
    @search_flg = false
    if request.get?
      if @meeting.have_enough_members?
        redirect_to wizard_path(:schedule)
      else
        @parents = parents
        render_wizard
      end
    else
      @meeting.members << current_user.parents.find(params[:parent_id])
      if @meeting.save
        redirect_to wizard_path(:schedule)
      else
        render action: 'parent'
      end
    end
  end

  def schedule
    if request.get?
      if @meeting.schedules_full?
        redirect_to next_wizard_path
      elsif @meeting.have_enough_members?
        @meeting_schedule = MeetingSchedule.new
        render_wizard
      else
        redirect_to wizard_path(:member_type)
      end
    else
      date = Date.parse(params[:date])
      t = Time.new(date.year, date.month, date.day, params[:time][:hour], params[:time][:minute])
      @meeting_schedule = MeetingSchedule.new(datetime: t)
      @meeting.schedules << @meeting_schedule
      if @meeting.save
        redirect_to wizard_path
      else
        @meeting.schedules.delete(@meeting_schedule)
        render_wizard
      end
    end
  end

  def confirmation
    if request.get?
      render_wizard
    else
      render_wizard @meeting
    end
  end

  def finish
    @meeting.finish_registering
    if @meeting.valid?
      render_wizard
    else
      redirect_to wizard_path(:confirmation)
    end
  end

  private

  def students
    exclusions = @meeting.member_ids
    if params[:q]
      @search_flg = true
      current_user.search_students(params[:q], active:true).select{|s| !exclusions.include?(s.id)}
    else
      if exclusions.present?
        current_user.active_students.where('users.id NOT IN (?)', exclusions).page(params[:page])
      else
        current_user.active_students.page(params[:page])
      end
    end
  end

  def parents
    exclusions = @meeting.member_ids
    if params[:q]
      @search_flg = true
      current_user.search_parents(params[:q], active:true).select{|s| !exclusions.include?(s.id)}
    else
      if exclusions.present?
        current_user.active_parents.where('users.id NOT IN (?)', exclusions).page(params[:page])
      else
        current_user.active_parents.page(params[:page])
      end
    end
  end

  def finish_wizard_path
    root_path
  end
end

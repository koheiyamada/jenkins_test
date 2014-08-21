class St::TutorOptionalLessonsController < ApplicationController
  include StudentAccessControl
  before_filter :prepare_tutor
  before_filter :prepare_units, :only => :new
  layout 'with_sidebar'

  def new
    current_user.clear_incomplete_lessons
    @optional_lesson = OptionalLesson.new_for_form
    @optional_lesson.creator = current_user
    @optional_lesson.students = [current_user]
    if @optional_lesson.save
      redirect_to st_tutor_optional_lesson_forms_path(@tutor, @optional_lesson)
    else
      render action:"new"
    end

  end

  def create
    @lesson = OptionalLesson.new(params[:optional_lesson])
    @lesson.tutor = @tutor
    @lesson.students << current_user
    if @lesson.is_group_lesson
      @lesson.friend = current_user.students.find_by_user_name(params[:friend])
    end
    @lesson.save!
    TutorMailer.lesson_request_arrived(@lesson).deliver
    redirect_to st_lessons_path
  rescue ActiveRecord::RecordInvalid => e
    prepare_units
    render action:"new"
  end


  private
    def prepare_units
      @units = (current_user.min_lesson_units .. 5)
    end

end

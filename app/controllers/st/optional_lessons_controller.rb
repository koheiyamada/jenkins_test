class St::OptionalLessonsController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'
  before_filter :prepare_units, :only => :new

  def index
    redirect_to requests_st_lessons_path
  end

  def new
    current_user.clear_incomplete_lessons
    @optional_lesson = OptionalLesson.new_for_form
    @optional_lesson.creator = current_user
    @optional_lesson.students = [current_user]
    if @optional_lesson.save
      redirect_to st_optional_lesson_forms_path(@optional_lesson)
    else
      render action:"new"
    end
  end

  def create
    @lesson = OptionalLesson.new(params[:optional_lesson])
    @lesson.students << current_user
    @lesson.save!
    TutorMailer.lesson_request_arrived(@lesson).deliver
    redirect_to action:"index"
  rescue ActiveRecord::RecordInvalid => e
    prepare_units
    render action:"new"
  end

  private
    def prepare_units
      @units = (current_user.min_lesson_units .. 5)
    end

end

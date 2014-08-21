class Hq::Students::OptionalLessonsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :lesson
  before_filter :prepare_student
  layout 'with_sidebar'

  def index
    @optional_lessons = @student.optional_lessons.future
  end

  def new
    current_user.clear_incomplete_lessons
    @optional_lesson = OptionalLesson.new_for_form
    @optional_lesson.creator = current_user
    @optional_lesson.students << @student
    if @optional_lesson.save
      redirect_to hq_optional_lesson_forms_path(@optional_lesson, params)
    else
      render action:"new"
    end
  end
end

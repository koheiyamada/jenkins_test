class Tu::Lessons::Students::DropoutsController < ApplicationController
  tutor_only
  before_filter :prepare_lesson
  before_filter :prepare_student

  def create
    lesson_dropout = @student.drop_out_from_lesson @lesson
    if lesson_dropout.persisted?
      render json:{success:1, remaining_student_count: @lesson.lesson_students.remaining.count}
    else
      render json:{success:0, error_messages: lesson_dropout.errors.full_messages}
    end
  end
end

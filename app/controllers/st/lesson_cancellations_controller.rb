class St::LessonCancellationsController < ApplicationController
  student_only
  layout 'with_sidebar'

  before_filter do
    @lesson = current_user.lessons.find(params[:lesson_id])
    @student = current_user
    @lesson_student = @lesson.student(@student)
  end

  def new
    @lesson_cancellation = @lesson_student.build_lesson_cancellation
  end

  def create
    @lesson_cancellation = @lesson_student.build_lesson_cancellation(params[:lesson_cancellation])
    if @lesson_cancellation.save
      if current_user.free?
        current_user.count_down_free_lesson_reservation
      end
      redirect_to st_lesson_path(@lesson)
    else
      render :new
    end
  end
end

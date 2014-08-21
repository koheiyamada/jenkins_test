class Tu::LessonCancellationsController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  before_filter do
    @lesson = current_user.lessons.find(params[:lesson_id])
  end

  def new
    @tutor_lesson_cancellation = @lesson.build_tutor_lesson_cancellation
  end

  def create
    @tutor_lesson_cancellation = @lesson.build_tutor_lesson_cancellation(params[:tutor_lesson_cancellation])
    if @tutor_lesson_cancellation.save
      Student.new.count_down_free_lesson_reservation(@lesson.students[0].id)
      redirect_to tu_lesson_path(@lesson)
    else
      render :new
    end
  end
end

class Tu::LessonRequestRejectionsController < LessonsController
  tutor_only

  before_filter do
    @lesson = Lesson.find(params[:lesson_request_id])
  end

  def new
    @lesson_request_rejection = @lesson.build_lesson_request_rejection
  end

  def create
    @lesson_request_rejection = @lesson.build_lesson_request_rejection(params[:lesson_request_rejection])
    if @lesson_request_rejection.save
      Student.new.count_down_free_lesson_reservation(@lesson.creator_id)
      redirect_to tu_lesson_requests_path, notice: t('messages.rejected_lesson')
    else
      render :new
    end
  end
end

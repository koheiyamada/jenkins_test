class Tu::Lessons::StudentsController < StudentsController
  tutor_only
  before_filter :prepare_lesson

  # lessons/:id/students/in_room
  # レッスンに参加している生徒
  def in_room
    @students = @lesson.lesson_students.where('attended_at IS NOT NULL').includes(:lesson_extension_request)
    respond_to do |format|
      format.json do
        render json:@students.as_json(:include => :lesson_extension_request)
      end
    end
  end

  def show
    @student = @lesson.students.find(params[:id])
  end
end

class Bs::LessonsController < LessonsController
  include LessonRoom
  bs_user_only

  def index
    @lessons = subject.lessons.includes(:tutor).future.fixed.page(params[:page])
  end

  def show
    @lesson = current_user.lessons.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render json:lesson_to_json(@lesson)
      end
    end
  end

  def room_as_tutor
    @lesson = current_user.lessons.find(params[:id])
    render layout:"lesson_room"
  end

  def room_as_student
    @lesson = current_user.lessons.find(params[:id])
    if params[:student_id]
      @student = @lesson.students.find(params[:student_id])
      render layout:"lesson_room"
    else
      redirect_to action:"show"
    end
  end

  def new
  end
end

class Tu::LessonsController < LessonsController
  include MessageHandler
  tutor_only
  layout 'with_sidebar'
  after_filter :room_entered, :only => :room

  # POST /tu/lessons/:id/open
  def open
    @lesson = current_user.lessons.find(params[:id])
    @lesson.open!
    render json:lesson_to_json(@lesson)
  end

  # POST /tu/lessons/:id/check_in.json
  def check_in
    @lesson = current_user.lessons.find(params[:id])
    @lesson.tutor_attended
    respond_to do |format|
      format.json{render json:lesson_to_json(@lesson)}
    end
  end

  # POST /tu/lessons/:id/close
  def close
    @lesson = current_user.lessons.find(params[:id])
    @lesson.close!
    render json:lesson_to_json(@lesson)
  end

  # GET
  # POST
  def change_schedule
    @lesson = current_user.lessons.find(params[:id])
    if @lesson.schedule_changeable?
      if request.post?
        @message = parse_message_params
        if @message.save
          @lesson.reschedule!
          redirect_to action:"show"
        else
          # do nothing
        end
      else
        @message = Message.new do |m|
          m.title = t("messages.changing_lesson_schedule")
          m.text = render_to_string partial:"change_schedule_message"
        end
      end
    else
      redirect_to action: :show
    end
  end

  def accept_cancellation
    @lesson = current_user.lessons.find(params[:id])
    @student = @lesson.students.find_by_id(params[:student_id])
    if @student
      if @student.leave_lesson(@lesson)
        render json:{success:1}
      else
        render json:{success:0, error_message:"Failed to leave lesson"}
      end
    else
      render json:{success:0, error_message:"Invalid student ID"}
    end
  end

  private

    def room_entered
      if response.status == 200
        @lesson.tutor_entered
      end
    end
end

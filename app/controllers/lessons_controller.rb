class LessonsController < ApplicationController
  include LessonRoom
  layout 'with_sidebar'

  def index
    @lessons = lessons.future.fixed.for_list.page(params[:page])
  end

  def history
    @lessons = lessons.past.only_done.for_list.order('start_time DESC').page(params[:page])
  end

  def unreported
    @lessons = lessons.unreported.for_list.order('start_time DESC').page(params[:page])
  end

  def under_request
    @lessons = lessons.future.not_confirmed.for_list.order('start_time').page(params[:page])
  end

  def pending
    @lessons = lessons.future.not_confirmed.for_list.order('start_time').page(params[:page])
  end

  def not_started
    @lessons = lessons.not_started.for_list.order('start_time DESC').page(params[:page])
  end

  def show
    @lesson = lessons.find_by_id(params[:id])
    respond_to do |format|
      format.html do
        if @lesson.nil?
          render action:'nonexistent_lesson'
        end
      end
      format.json do
        render json:lesson_to_json(@lesson)
      end
    end
  end

  # GET
  # POST
  def change_schedule
    if request.get?
      @lesson = lessons.find(params[:id])
      unless @lesson.schedule_changeable?
        redirect_to action: :show
      end
    else
      @lesson = lessons.find(params[:id], readonly: false)
      date = Date.parse(params[:date])
      @lesson.start_time = Time.new(date.year, date.month, date.day, params[:time][:hour], params[:time][:minute])
      if @lesson.save
        redirect_to({action:"show"}, notice:t("messages.lesson_schedule_changed"))
      else
        render action:"change_schedule"
      end
    end
  end

  # GET /:role/lessons/:id/room
  def room
    @lesson = lessons.find(params[:id])
    if current_user.can_enter_lesson?(@lesson)
      render layout:'lesson_room'
    else
      redirect_to action: :show
    end
  end

  def room_as_tutor
    @lesson = lessons.find(params[:id])
    if current_user.can_enter_lesson?(@lesson)
      render layout: 'lesson_room'
    else
      redirect_to action: :show
    end
  end

  def room_as_student
    @lesson = lessons.find(params[:id])
    if current_user.can_enter_lesson?(@lesson) && params[:student_id]
      @student = @lesson.students.find(params[:student_id])
      render layout: 'lesson_room'
    else
      redirect_to action: :show
    end
  end

  # POST /:role/lessons/:id/cancel
  def cancel
    @lesson = lessons.find(params[:id], readonly: false)
    if request.get?

    else
      if @lesson.cancel_by(current_user)
        unless @lesson.type == "BasicLesson"
          Student.new.count_down_free_lesson_reservation(@lesson.students[0].id)
        end
        redirect_to({action:"index"}, :notice => t("messages.lesson_canceled"))
      else
        redirect_to({action:"show"}, :notice => t('lesson.message.failed_to_cancel'))
      end
    end
  end

  def cancel_request
    @lesson = lessons.under_request.find_by_id(params[:id])
    if @lesson.nil?
      redirect_to action:'show'
    else

      Student.new.count_down_free_lesson_reservation(@lesson.students[0].id)
      @lesson.destroy
      redirect_to({action:'under_request'}, :notice => t('messages.lesson_canceled'))
    end
  end

  # GET lessons/:id/exendable
  def extendable
    @lesson = lessons.find(params[:id])
    @error_reason = @lesson.check_extendability
    respond_to do |format|
      format.json do
        if @error_reason.blank?
          render json:{extendable:true, message:t("messages.extendable")}
        else
          logger.info @error_reason
          render json:{extendable:false, reason:@error_reason}
        end
      end
    end
  end

  def extendability
    @lesson = lessons.find(params[:id])
    @lesson_extendability = @lesson.extendability
    respond_to do |format|
      format.json do
        render json:@lesson_extendability.to_json
      end
    end
  end

  def extension
    @lesson = lessons.find(params[:id])
    render layout:false if request.xhr?
  end

  def time_schedule
    @lesson = lessons.find(params[:id])
    render layout:false if request.xhr?
  end

  def updated_at
    lesson = lessons.select('lessons.updated_at').find(params[:id])
    respond_to do |format|
      format.json do
        render json: lesson
      end
    end
  end

  private

    def lessons
      subject.lessons
    end

    def subject
      current_user
    end
end

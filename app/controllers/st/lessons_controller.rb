class St::LessonsController < LessonsController
  include StudentAccessControl
  include MessageHandler
  student_only
  layout 'with_sidebar', :except => :room
  after_filter :room_entered, :only => :room

  def group
    if params[:q]
      @lessons = Lesson.search do
        with :recruiting, true
        with(:start_time).greater_than(15.minutes.from_now)
        #paginate :page => params[:page].to_i, :per_page => 25
        if params[:tutor_id]
          with :tutor_id, params[:tutor_id].to_i
        end
        day = parse_date(params[:date])
        if day
          with(:start_time).between(day.beginning_of_day .. day.end_of_day)
        else
          params[:date] = nil
        end
        order_by :start_time
        fulltext SearchUtils.normalize_key(params[:q])
      end.results
    else
      @lessons = Lesson.future.recruiting.page(params[:page])
    end
  end

  def requests
    @lessons = current_user.lessons.not_confirmed.future.page(params[:page])
  end

  # GET lessons/invited
  def invited
    @lessons = current_user.invited_lessons.going_to_be_held.page(params[:page])
  end

  # GET lessons/:id/invited
  def invited_lesson
    @lesson = current_user.invited_lessons.find(params[:id])
  end

  # POST /tu/lessons/:id/check_in.json
  def check_in
    @lesson = current_user.lessons.find(params[:id])
    @lesson.student_attended(current_user)
    respond_to do |format|
      format.json{render json:lesson_to_json(@lesson)}
    end
  end

  # POST lessons/:id/accept_invitation
  def accept_invitation
    # 申込中のレッスンか、開催待ちのレッスンの招待のみを承諾することができる。
    @lesson = current_user.invited_lessons.going_to_be_held.find_by_id(params[:id])
    if @lesson
      @lesson.invitation_accepted(current_user)
      redirect_to st_lesson_path(@lesson)
    else
      redirect_to invited_st_lessons_path, notice: t('lesson.message.failed_to_accept_invitation')
    end
  end

  # POST lessons/:id/reject_invitation
  def reject_invitation
    @lesson = current_user.invited_lessons.find(params[:id])
    @lesson.invitation_rejected(current_user)
    redirect_to invited_st_lessons_path, notice:t("messages.rejected_lesson_invitation")
  end

  def no_cs_sheet
    @lessons = current_user.lessons.only_done.no_cs_sheet_by(current_user).order("start_time").page(params[:page])
  end

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
          m.recipients = current_user.organization.message_recipients
          m.title = t("messages.changing_lesson_schedule")
          m.text = render_to_string partial:"change_schedule_message"
        end
      end
    else
      redirect_to action: :show
    end
  end

  #def room
  #  super
  #  @lesson.student_attended(current_user)
  #end

  def materials
    @lesson_materials = @lesson.materials.owned_by(current_user)
    respond_to do |format|
      json do
        images = @lesson_materials.map(&:url)
        render json:{images:images}
      end
    end
  end

  def reserve
    redirect_to st_tutors_path if current_user.free?
  end

  def update
  end

  def cancel
    @lesson = current_user.lessons.find(params[:id])
    @lesson_cancellation = current_user.cancel_lesson(@lesson)
    if @lesson_cancellation.errors.empty?
      redirect_to({action:'show'}, :notice => t("messages.lesson_canceled"))
    else
      logger.info "Failed to cancel lesson #{@lesson.id}, #{@lesson_cancellation.errors.full_messages}"
      render :show
    end
  end

  # POST lessons/:id/leave
  def leave
    @lesson = current_user.lessons.find(params[:id])
    lesson_dropout = current_user.drop_out_from_lesson @lesson
    if lesson_dropout.persisted?
      render json:{success:1, lesson:lesson_to_json(@lesson)}
    else
      render json:{success:0, error_message: "Failed to leave lesson", error_messages: lesson_dropout.errors.full_messages}
    end
  end

  def left
    @lesson = current_user.lessons.find(params[:id])
    if current_user.free?
      current_user.count_down_free_lesson_reservation
    end
    redirect_to new_st_lesson_cs_sheet_path(@lesson)
  end

  def destroy
    @lesson = current_user.lessons.find(params[:id])
    @lesson.destroy
    redirect_to action:"index"
  end

  private

    def parse_date(date_string)
      Date.parse(date_string)
    rescue
      nil
    end

    def room_entered
      if response.status == 200
        @lesson.student_entered(current_user)
      end
    end
end

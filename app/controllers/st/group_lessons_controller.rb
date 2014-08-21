class St::GroupLessonsController < LessonsController
  include StudentAccessControl
  student_only

  def index
    if params[:q]
      @lessons = search_shared_lessons
    else
      @lessons = Lesson.available_shared_lessons.page(params[:page])
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  # POST group_lessons/:id/join
  def join
    @lesson = Lesson.future.find(params[:id])
    if @lesson.add_student(current_user)
      redirect_to st_lesson_path(@lesson), notice: t("lesson.message.joined")
    else
      render :show
    end
  end

  private

    def parse_date(date_string)
      Date.parse(date_string)
    rescue
      nil
    end

    def search_shared_lessons
      SharedOptionalLesson.search do
        #with :recruiting, true
        with :style, 'shared'
        with :full, false
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
    end
end

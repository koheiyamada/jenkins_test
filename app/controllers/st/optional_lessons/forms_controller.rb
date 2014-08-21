class St::OptionalLessons::FormsController < ApplicationController
  student_only
  layout 'with_sidebar'
  include Wicked::Wizard

  steps :tutor, :schedule, :student, :confirmation

  def show
    @optional_lesson = Lesson.find(params[:optional_lesson_id])
    send step
    render_wizard
  end

  def update
    OptionalLesson.transaction do
      @optional_lesson = Lesson.find(params[:optional_lesson_id])
      send step
      render_wizard @optional_lesson unless step == :group_lesson
    end
  end

  def group_lesson
    if request.get?
    else
      if params[:no_group_lesson]
        @optional_lesson.update_attribute(:is_group_lesson, false)
        redirect_to wizard_path(:confirmation)
      elsif params[:not_select_student]
        @optional_lesson.group_lesson!
        redirect_to wizard_path(:confirmation)
      elsif params[:select_student]
        @optional_lesson.group_lesson!
        render_wizard(@optional_lesson)
      else
        render_wizard(@optional_lesson)
      end
    end
  end

  def student
    if request.get?
      if @optional_lesson.full?
        skip_step
      elsif @optional_lesson.shared_lesson?
        skip_step
      else
        @students = find_students
      end
    else
      @student = Student.find(params[:member_id])
      @optional_lesson.invite!(Student.find(@student))
    end
  end

  def tutor
    if request.get?
      if @optional_lesson.tutor.present?
        skip_step
      else
        @tutors = find_tutors
      end
    else
      @tutor = current_user.tutors.find(params[:tutor_id])
      @optional_lesson.tutor = @tutor
      if @optional_lesson.save
      else
        @tutors = current_user.tutors.page(params[:page])
      end
    end
  end

  def schedule
    if request.get?
      @optional_lesson.start_time = 1.hour.from_now
    else
      date = Date.parse(params[:date])
      time = Time.zone.local(date.year, date.month, date.day, params[:time][:hour], params[:time][:minute])
      @optional_lesson.start_time = time
      @optional_lesson.attributes = params[:optional_lesson]

      #無料体験申込みの期限内であるかチェックする
      if current_user.free?
        available_flg = current_user.check_if_before_expiration_date(@optional_lesson.start_time)
        unless available_flg == true
          @available_flg = available_flg
#          new_st_optional_lesson_path
          requests_st_lessons_path
        end
      end
    end
  end

  def confirmation
    if request.get?
    else
      @optional_lesson.fix!
      current_user.count_up_free_lesson_reservation
    end
  end

  def finish

  end

  def cancel
    @optional_lesson = OptionalLesson.find(params[:optional_lesson_id])
    @optional_lesson.destroy
    redirect_to st_lessons_path
  end

  private

    def finish_wizard_path
      requests_st_lessons_path
    end

    def prepare_available_times
      @tutor = current_user.tutors.find(@optional_lesson.tutor.id)

      @month = (params[:month] || (Time.zone || Time).now.month).to_i
      @year = (params[:year] || (Time.zone || Time).now.year).to_i
      @shown_month = Date.civil(@year, @month)
      @event_strips = AvailableTime.event_strips_for_month(@shown_month,
                                                           :conditions => {tutor_id:@tutor.id})
    end

    def find_students
      if params[:q]
        search_students([current_user.id])
      else
        Student.only_active.where('id != ?', current_user.id).page(params[:page])
      end
    end

    def search_students(exclusions=[])
      page = (params[:page] || 1).to_i
      options = {
        active: true,
        without: exclusions,
        page: page,
        exclude_trial: true
      }
      current_user.search_students(params[:q], options)
    end

    def find_tutors
      if params[:q]
        search_tutors
      else
        find_default_tutors
      end
    end

    def search_tutors
      options = {active: true}
      options = options.merge(undertake_group_lesson: true) if @optional_lesson.is_group_lesson
      current_user.search_tutors(params[:q], options)
    end

    def find_default_tutors
      if @optional_lesson.is_group_lesson?
        current_user.tutors.undertake_group_lesson.page(params[:page])
      else
        current_user.tutors.page(params[:page])
      end
    end
end

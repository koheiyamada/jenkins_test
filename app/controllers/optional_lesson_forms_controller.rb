class OptionalLessonFormsController < ApplicationController
  include Wicked::Wizard
  include TutorSearchable
  include WizardHelper
  layout 'with_sidebar'

  before_filter :check_session,           except: :index
  before_filter :prepare_optional_lesson, except: :index
  before_filter :reset_field,             except: :index
  before_filter :check_skip,              except: :index

  steps :student, :check_members, :tutor, :schedule, :confirmation

  def index
    init_session
    super
  end

  def show
    send step
    render_wizard unless performed?
  end

  def update
    OptionalLesson.transaction do
      send step
      render_wizard @optional_lesson unless performed?
    end
  end

  def student
    if request.get?
      if @optional_lesson.full?
        skip_step
      else
        @students = find_students
      end
    else
      student = current_user.students.find(params[:member_id])
      if student.present? && !@optional_lesson.member_student?(student)
        @optional_lesson.students << student
      end
    end
  end

  def check_members
    if @optional_lesson.full?
      skip_step
      render_wizard
    else
      redirect_to previous_wizard_path
    end
  end


  def tutor
    if request.get?
      if @optional_lesson.is_group_lesson
        params[:undertake_group_lesson] = '1'
      end
      @tutors = find_tutors
    else
      @tutor = current_user.active_tutors.find(params[:tutor_id])
      @optional_lesson.tutor = @tutor
      if @optional_lesson.save
      else
        @tutors = current_user.active_tutors.page(params[:page])
      end
    end
  end

  def schedule
    if request.get?
      if @optional_lesson.students.empty?
        redirect_to wizard_path(:student), alert: t('optional_lesson.students_should_not_be_empty')
      else
        @optional_lesson.start_time ||= 1.hour.from_now
      end
    else
      date = Date.parse(params[:date])
      time = Time.zone.local(date.year, date.month, date.day, params[:time][:hour], params[:time][:minute])
      @optional_lesson.start_time = time
      @optional_lesson.attributes = params[:optional_lesson]
    end
  end

  def confirmation
    if request.get?
      if resolve_step_to_go != :confirmation
        redirect_to wizard_path(resolve_step_to_go)
      end
    else
      Student.new.count_up_free_lesson_reservation(@optional_lesson.students[0].id)
      unless @optional_lesson.fix
        redirect_to wizard_path(resolve_step_to_go)
      end
    end
  end

  def finish
    clear_session
  end

  def cancel
    if @optional_lesson.present?
      @optional_lesson.destroy
    end
    redirect_to redirect_path_on_cancellation, notice: t('optional_lesson.request_is_cancelled')
    clear_session
  end

  private

    def resolve_step_to_go
      if @optional_lesson.students.empty?
        :student
      elsif @optional_lesson.tutor.blank?
        :tutor
      elsif @optional_lesson.start_time.blank?
        :schedule
      else
        :confirmation
      end
    end

  def finish_wizard_path
    root_path
  end

  def prepare_available_times
    @tutor = current_user.tutors.find(@optional_lesson.tutor.id)

    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = AvailableTime.event_strips_for_month(@shown_month,
                                                         :conditions => {tutor_id:@tutor.id})
  end

  def redirect_path_on_cancellation
    root_path
  end

  def find_tutors
    if params[:q]
      if @optional_lesson.multi_student_lesson?
        params[:regular_only] = true
      end
      search_tutors(params)
    else
      find_default_tutors
    end
  end

  def search_tutors(options)
    @tutor_search = TutorSearchForOptionalLessons.new(options)
    @tutor_search.execute
  end

  def find_default_tutors
    if @optional_lesson.multi_student_lesson?
      current_user.active_tutors.only_regular.undertake_group_lesson.page(params[:page])
    else
      current_user.active_tutors.page(params[:page])
    end
  end

  def find_students
    member_ids = @optional_lesson.student_ids
    if params[:q]
      search_students(member_ids)
    else
      find_default_students(member_ids).page(params[:page])
    end
  end

  def search_students(exclusions=[])
    page = (params[:page] || 1).to_i
    options = {
      active: true,
      without: exclusions,
      page: page,
      lesson_style: @optional_lesson.style,
      exclude_trial: true
    }
    current_user.search_students(params[:q], options)
  end

  def find_default_students(exclusions=[])
    if exclusions.present?
      current_user.active_students.exclude_trial.where('users.id NOT IN (?)', exclusions)
    else
      current_user.active_students.exclude_trial.page(params[:page])
    end
  end

  def lesson_id
    params[:optional_lesson_id]
  end
  
    #
    # フィルター
    #

    def prepare_optional_lesson
      @optional_lesson = OptionalLesson.find(lesson_id)
    end
  
    def check_skip
      if request.get? && should_skip?
        skip_step
        render_wizard
      end
    end
  
    def should_skip?
      case step
      when :tutor
        @optional_lesson.tutor.present? && !params[:reset]
      when :student
        @optional_lesson.full? && !params[:reset]
      else
        false
      end
    end
  
    def reset_field
      if request.get? && params[:reset]
        case step
        when :tutor
          @optional_lesson.update_attribute :tutor_id, nil
        when :student
          @optional_lesson.students.clear
        end
      end
    rescue => e
      logger.error e
    end

    #
    # セッション管理
    #

    def on_wizard_session_inconsistent
      redirect_to wizard_path, notice: t('optional_lesson.do_not_use_back_button')
    end

    def on_wizard_session_empty
      redirect_to redirect_path_on_cancellation, alert: t('optional_lesson.do_not_use_back_button')
    end

    def wizard_session_key
      :optional_lesson_form
    end
end

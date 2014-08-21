class BasicLessonInfoFormsController < ApplicationController
  layout 'with_sidebar'
  include Wicked::Wizard
  include TutorSearchable

  class FormSession
    def update_step(step)
      @current_step = step
    end

    def check_step(step)
      @current_step == step
    end

    attr_reader :current_step
  end

  before_filter :check_session, except: :index
  before_filter :prepare_basic_lesson_info, except: :index
  before_filter :reset_field, except: :index
  before_filter :check_skip, except: :index

  steps :member, :group_lesson, :tutor, :wday_schedule, :confirmation

  def show
    send step
    render_wizard unless performed?
  end

  def update
    send step
    render_wizard @basic_lesson_info unless performed?
  end

  def index
    session[:basic_lesson_info_form] ||= FormSession.new
    super
  end

  def group_lesson
    if request.get?
      if @basic_lesson_info.full?
        skip_step
      else
        redirect_to previous_wizard_path
      end
    else
      @basic_lesson_info.attributes = params[:basic_lesson_info]
    end
  end

  def tutor
    if request.get?
      if @basic_lesson_info.can_have_multiple_students?
        params[:undertake_group_lesson] = '1'
      end
      @tutors = find_tutors
    else
      @tutor = current_user.active_tutors.find(params[:tutor_id])
      @basic_lesson_info.tutor = @tutor
      unless @basic_lesson_info.save
        @tutors = current_user.active_tutors.page(params[:page])
      end
    end
  end

  def member
    if request.get?
      @students = find_students

      # お友達レッスン or 同時レッスン選択時は無料会員非表示
      if @basic_lesson_info.type == "FriendsBasicLessonInfo" || @basic_lesson_info.type == "SharedBasicLessonInfo"
        st_tmp = find_students
        cnt = 0

        @students.each do |st|
          if st.customer_type == "free" || st.customer_type == "request_to_premium"
            st_tmp.delete_at(cnt)
            cnt -= 1
          end
          cnt += 1
        end
        @students = st_tmp
      end
      
    else
      student = Student.only_active.find(params[:member_id])
      if @basic_lesson_info.student_acceptable? student
        @basic_lesson_info.students << student
      else
        @basic_lesson_info.errors.add :students, :failed_to_add_student
      end
    end
  end

  def wday_schedule
    if request.get?
      if @basic_lesson_info.students.empty?
        redirect_to wizard_path(:member), alert: t('basic_lesson_info.students_should_not_be_empty')
      else
        @basic_lesson_info.schedules.build if @basic_lesson_info.schedules.empty?
      end
    else
      if params[:basic_lesson_info].nil? || params[:basic_lesson_info][:schedules_attributes].blank?
        @basic_lesson_info.errors.add :schedules, :at_least_one
        @basic_lesson_info.schedules.build
        render_wizard
      else
        unless @basic_lesson_info.update_attributes params[:basic_lesson_info]
          render_wizard
        end
      end
    end
  end

  def confirmation
    if request.get?
      @basic_lesson_info.status = 'active'
      @basic_lesson_info.valid?
    else
      # チューターの承認待ち状態に移行する
      unless @basic_lesson_info.submit_to_tutor
        render_wizard
      end
    end
  end

  def cancel
    @basic_lesson_info = BasicLessonInfo.find_by_id(params[:basic_lesson_info_id])
    if @basic_lesson_info
      @basic_lesson_info.destroy
    end
    redirect_to redirect_path_on_cancellation, notice: t('basic_lesson_info.request_is_cancelled')
    clear_session
  end

  def finish
    clear_session
  end

  private

    def check_session
      if session[:basic_lesson_info_form]
        if request.get?
          session[:basic_lesson_info_form].update_step step
        else
          unless session[:basic_lesson_info_form].check_step step
            redirect_to wizard_path, notice: t('basic_lesson_info.do_not_use_back_button')
          end
        end
      else
        redirect_to redirect_path_on_cancellation, alert: t('basic_lesson_info.do_not_use_back_button')
      end
    end

    def prepare_basic_lesson_info
      @basic_lesson_info = BasicLessonInfo.find(params[:basic_lesson_info_id])
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
        @basic_lesson_info.tutor.present? && !params[:reset]
      when :member
        @basic_lesson_info.full? && !params[:reset]
      else
        false
      end
    end

    def reset_field
      if request.get? && params[:reset]
        case step
        when :tutor
          @basic_lesson_info.update_attribute :tutor_id, nil
        when :member
          @basic_lesson_info.students.clear
        end
      end
    rescue => e
      logger.error e
    end

    def clear_session
      session[:basic_lesson_info_form] = nil
      logger.info 'Basic lesson form session cleared.'
    end

    def finish_wizard_path
      root_path
    end

    def redirect_path_on_cancellation
      root_path
    end

    def find_tutors
      if params[:q]
        search_tutors(params.merge(regular_only: true))
      else
        if @basic_lesson_info.can_have_multiple_students?
          current_user.active_tutors.only_regular.undertake_group_lesson.page(params[:page])
        else
          current_user.tutors.only_active.only_regular.page(params[:page])
        end
      end
    end

    def search_tutors(options)
      @tutor_search = TutorSearch.new(options)
      @tutor_search.execute
    end

    # レッスンに参加する受講者の選択肢を返す
    def find_students
      member_ids = @basic_lesson_info.student_ids
      if params[:q]
        search_students(member_ids)
      else
        find_default_students(member_ids).page(params[:page])
      end
    end

    # レッスンに参加する受講者を検索で探す
    def search_students(exclusions=[])
      page = (params[:page] || 1).to_i
      options = {active: true, without: exclusions, page: page, lesson_style: @basic_lesson_info.style, exclude_trial: true}
      conditions = {'customer_type' => 'premium'}
      current_user.search_students(params[:q], options, conditions)
    end

    # レッスンに参加しうる受講者を返す
    def find_default_students(exclusions=[])
      if exclusions.empty?
        current_user.active_students.exclude_trial.where(customer_type: :premium)
      else
        current_user.active_students.exclude_trial.where('users.id NOT IN (?)', exclusions)
      end
    end
end


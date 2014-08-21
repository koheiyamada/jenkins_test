# encoding:utf-8

class BasicLesson < Lesson
  include BasicLessonMoneyMethods

  belongs_to :course, class_name:BasicLessonInfo.name

  attr_accessor :month, :time_of_day
  attr_accessible :course

  validates_presence_of :course
  validate :ensure_not_duplicate, on: :create

  ###########################################################
  # Hooks
  ###########################################################
  before_validation :fill_fields, if: :course_id
  before_validation LessonChargingMonitor

  after_create do
    # ベーシックレッスンは作成されたら自動的に受付済み状態にする
    accept!
    logger.lesson_log("CREATED", attributes)
  end

  after_update do
    if tutor_id_changed? && !tutor_id_was.nil?
      if course.present?
        course.on_lesson_tutor_changed(self)
      end
    end
  end

  #
  #
  #

  def optional?
    false
  end

  def basic?
    true
  end

  def max_student_count
    course.max_students_count
  end

  ## このレッスンに関する決済日
  #def settlement_date
  #  start_time.beginning_of_month.to_date
  #end

  def payment_month
    DateUtils.aid_month_of_day(original_start_time).prev_month
  end

  # 生徒がこのレッスンを今キャンセルできる場合trueを返す
  def cancellable_by_student?(student)
    false
  end

  def cancellable_by_tutor?
    now = Time.now
    if now > entry_start_time_for(tutor)
      false
    else
      true
    end
  end

  def cancellable_by_bs_user?(bs_user)
    if start_time > 0.minutes.ago(start_time)
      false
    else
      true
    end
  end

  def cancellable_by_hq_user?(hq_user)
    future? && !cancelled?
  end

  def time_changeable?
    if course.blank?
      true
    else
      course.lesson_time_changable?(self)
    end
  end

  def cancellation_period_for?(user)
    if user.tutor?
      Time.current < entry_start_time_for(user)
    elsif user.student?
      false
    else
      true
    end
  end

  def change_time!(time)
    transaction do
      super
      if course.present?
        course.on_lesson_time_changed(self)
      end
    end
  end

  def friends_lesson?
    course.friends_lesson?
  end

  def shared_lesson?
    course.shared_lesson?
  end

  def style
    if started? && !group_lesson?
      :single
    else
      if friends_lesson?
        :friends
      elsif shared_lesson?
        :shared
      else
        :single
      end
    end
  end

  private
    def check_conflicts_with_basic_lesson_infos
      if course
        # チューターの予定をチェック
        if tutor
          tutor.basic_lesson_infos.pending.where('basic_lesson_infos.id != :id', id:course.id).conflict_with(self, Lesson.min_interval).each do |basic_lesson_info|
            errors.add(:time_range,
                       :conflict_with_pending_basic_lesson_info_for_tutor,
                       time_ranges: basic_lesson_info.schedules.map{|s| s.time_range_string(:wday)}.join(', '))
          end
        end
        # 生徒の予定をチェック
        students.each do |student|
          student.basic_lesson_infos.pending.where('basic_lesson_infos.id != :id', id:course.id).conflict_with(self, Lesson.min_interval).each do |basic_lesson_info|
            errors.add(:time_range,
                       :conflict_with_pending_basic_lesson_info_for_student,
                       student: student.nickname,
                       time_ranges: basic_lesson_info.schedules.map{|s| s.time_range_string(:wday)}.join(', '))
          end
        end
      end
    end

    def ensure_not_duplicate
      if course.present? && course.lessons.conflict_with(self).present?
        errors.add :time_range, :duplicate
      end
    end

    def on_established
      super
      # メール通知、開始10分後処理をセットする
      reset_scheduled_jobs
    end

    def update_settlement_month
      if original_start_time
        m = DateUtils.aid_month_of_day(original_start_time).prev_month
        self.settlement_year = m.year
        self.settlement_month = m.month
      end
    end

    def fill_fields
      self.tutor = course.tutor if tutor.blank?
      self.subject = course.subject if subject.blank?
      self.students = course.students if students.blank?
      self.units = course.units if units.blank?
    end
end

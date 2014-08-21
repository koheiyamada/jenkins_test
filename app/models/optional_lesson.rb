class OptionalLesson < Lesson
  include OptionalLessonMoneyMethods

  attr_accessible :year, :month, :day, :hour, :min, :tutor_id, :subject_id
  attr_accessor :isgroup_lesson

  validate :now_is_before_request_time_limit, :if => :start_time_check_required?
  validate :ensure_before_time_limit_of_acceptance, :if => :accepting?
  validate :student_can_pay_fee, :if => :should_check_student_paying_capacity?
  validate :tutor_can_undertake_more_lessons, :if => :beginner_tutor?
  validate :ensure_within_tutor_daily_available_time, :if => :building_or_requesting?
  validate :student_can_reserve_free_lesson, :if => :include_free_student?
  validate :student_all_free_lesson_already_taken,
   :if => [:include_free_student?, :tutor?, :new?]


  before_validation LessonChargingMonitor

  after_update do
    if status_changed? && new?
      tutor.students += students # チューターの生徒リストに追加する
      logger.lesson_log("CREATED", attributes)
    end
  end

  after_update :send_mail_on_status_change


  def fix!
    super
    students.each do |student|
      self.type = FreeOptionalLesson.name if student.free?
    end
    save!
  end

  def fix
    super
    students.each do |student|
      self.type = FreeOptionalLesson.name if student.free?
    end
    save
  end

  def optional?
    true
  end

  def basic?
    false
  end

  def schedule_changeable?
    false
  end

  def cancellation_period_for?(user)
    if user.student? || user.tutor?
      Time.current < entry_start_time_for(user)
    else
      true
    end
  end

  def cancellable_by_student?(student)
    if !students.include?(student)
      false
    elsif student_cancelled?(student)
      false
    elsif new?
      # チューターがまだ承諾していない場合はキャンセルできる
      true
    elsif inactive?
      # レッスンの非開催が確定している場合はもうキャンセルできない
      false
    elsif Time.now > 10.minutes.ago(start_time)
      # レッスン開始10分を切った時点だと、まだ開催されていないときのみキャンセルできる。
      accepted?
    elsif !student.can_cancel_optional_lesson_for_month?(start_time)
      false
    else
      true
    end
  end

  def cancellable_by_tutor?
    if Time.now > entry_start_time_for(tutor)
      false
    elsif Time.now > cancellation_time_limit_for_tutor
      false
    else
      true
    end
  end

  def cancellable_by_bs_user?(bs_user)
    true
  end

  def cancellable_by_hq_user?(hq_user)
    !cancelled?
  end

  def have_enough_students?
    students.count > 0
  end

  def units_select_options
    (1 .. LessonSettings.max_units).to_a
  end

  private

    def beginner_tutor?
      tutor && tutor.beginner?
    end

    def tutor?
      tutor
    end

    def start_time_check_required?
      start_time.present? && (build? || new_record?)
    end

    def now_is_before_request_time_limit
      if start_time
        if Time.current >= request_time_limit
          self.errors.add(:start_time, :within_x_minutes, x: LessonSettings.request_time_limit)
        end
      end
    end

    def ensure_before_time_limit_of_acceptance
      if Time.current >= request_acceptance_time_limit
        errors.add(:start_time, :too_close_to_accept)
      end
    end

    def check_conflicts_with_basic_lesson_infos
      if tutor && start_time && end_time
        # 衝突判定をするのは、これからレッスンデータが作成される可能性のある、
        # 承認待ち中のものに限る。
        # すでにレッスンデータが作成されているベーシックレッスンについては
        if tutor
          tutor.basic_lesson_infos.conflictable_with_lesson(self).each do |basic_lesson_info|
            errors.add(:time_range,
                       :conflict_with_pending_basic_lesson_info_for_tutor,
                       time_ranges: basic_lesson_info.schedules.map{|s| s.time_range_string(:wday)}.join(', '))
          end
        end
        students.each do |student|
          student.basic_lesson_infos.conflictable_with_lesson(self).each do |basic_lesson_info|
            errors.add(:time_range,
                       :conflict_with_pending_basic_lesson_info_for_student,
                       student: student.nickname,
                       time_ranges: basic_lesson_info.schedules.map{|s| s.time_range_string(:wday)}.join(', '))
          end
        end
      end
    end

    def on_accepted
      reset_scheduled_jobs
      tutor.optional_lessons.not_fixed.conflict_with(self, Lesson.min_interval).each do |lesson|
        lesson.reject!
      end
      connect_tutor_and_students
    end

    def update_settlement_month
      if start_time
        m = DateUtils.aid_month_of_day(start_time)
        self.settlement_year = m.year
        self.settlement_month = m.month
      end
    end

    def should_check_student_paying_capacity?
      (build? && tutor_id? && start_time?)
    end

    def student_can_pay_fee
      students.each do |student|
        unless student.afford_to_take_lesson_from?(tutor, start_time)
          errors.add(:students, :over_payment_capacity)
          student.on_charge_limit_reached(self)
        end
      end
    end

    def tutor_can_undertake_more_lessons
      unless tutor.can_undertake_lesson?
        errors.add(:tutor, :cannot_undertake_more_lessons)
      end
    end

    def accepting?
      status_changed? && accepted?
    end

    def on_done
      super
      delay.update_accountings
    end

    def send_mail_on_status_change
      if status_changed?
        if new?
          Mailer.send_mail_async(:optional_lesson_requested, self)
        end
        if accepted?
          if status_was == 'new'
            Mailer.send_mail_async(:optional_lesson_accepted, self)
          end
        end
        if rejected?
          Mailer.send_mail_async(:optional_lesson_rejected, self)
        end
        if ignored?
          Mailer.send_mail_async(:optional_lesson_ignored, self)
        end
      end
    end

    # レッスンの時間帯がチューターの指導可能時間の範囲内かどうかをチェックする
    def ensure_within_tutor_daily_available_time
      if should_validate_schedule?
        if ready_to_check_tutor_schedule?
          unless within_tutor_daily_available_times?
            errors.add :time_range, :not_match_with_tutor_daily_available_times
          end
        end
      end
    end

    # レッスンの時間帯がチューターの指導可能時間の範囲内であればtrueを返す。
    # 開始時刻と終了時刻が別の指導可能時間範囲に属している場合、
    # それらの範囲間のギャップがゼロであれば一連の範囲であるとみなしてtrueを返す
    def within_tutor_daily_available_times?
      times = tutor.daily_available_times.of_times(start_time, end_time)
      if times.empty?
        false
      elsif times.count == 1
        times.first.include_range?(start_time, end_time)
      else # times.count > 1
        times[0...-1].zip(times[1..-1]).all?{|pair| pair[0].connected? pair[1]}
      end
    end

    # テストのためにチューターのスケジュールをいちいち設定する手間を省くためだけに使う。
    def should_validate_schedule?
      !Rails.env.test?
    end

    ### 無料レッスンである場合、無料レッスンを予約可能な条件が揃っているかチェック
    def student_can_reserve_free_lesson
      if start_time.present?
        unless within_student_free_lesson_available_times?
          errors.add :time_range, :student_can_not_free_lesson_reserve
        end
      end
    end

    ### レッスンの終了時刻が受講者の無料レッスン予約可能期間の範囲内であればtrue。
    def within_student_free_lesson_available_times?
      student = lesson_students.first.student
      student.check_if_before_expiration_date(end_time)
    end

    ### レッスン受講者に無料会員を含めばtrue。
    ### レッスン受講者がいない場合はfalse。
    def include_free_student?
      if lesson_students.present?
        lesson_students.each do |lesson_student|
          student = lesson_student.student
          if student.free?
            return true
          end
        end
        false
      else
        false
      end
    end

    ### 無料レッスンを全て消費していたらtrue
    def student_all_free_lesson_already_taken
      if all_free_lesson_taken?
        errors.add :students, :all_free_lesson_already_taken
      end
    end

    ### 無料レッスンを全て消費していたらtrue
    def all_free_lesson_taken?
      student = lesson_students.first.student
      student.all_free_lesson_taken
    end
end

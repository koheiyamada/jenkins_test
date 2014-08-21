class Tutor < User
  #include Ledgerable
  include BasicLessonMember
  include TutorMoneyMethods
  include BankAccountOwner
  include Searchable

  class << self

    def types
      @types ||= %w(Tutor BeginnerTutor SpecialTutor)
    end

    def max_beginner_lessons_count
      LessonSettings.instance.beginner_tutor_lessons_limit
    end

    def monitor_inactive_tutors
      detect_and_lock_inactive_tutors
      detect_and_send_warning_to_inactive_tutors
    end

    # ３ヶ月ログインしていないチューターをロックする
    def detect_and_lock_inactive_tutors
      tutors = Tutor.inactive_long_enough_to_leave
      logger.info "#{tutors.count} tutors are going to be locked because of not having logged in for more than 90 days."
      tutors.each do |tutor|
        logger.info "Tutor #{tutor.id} is being locked."
        mc = tutor.create_membership_cancellation(reason: I18n.t('tutor.has_not_logged_in_for_more_than_three_months'))
        if mc.persisted?
          logger.info "Tutor #{tutor.id} is locked."
        else
          logger.error mc.errors.full_messages
          logger.error "Failed to make Tutor #{tutor.id} leave because of not having logged in for more than 90 days."
        end
      end
    end

    # ３ヶ月近くログインしていないチューターに警告メールを出す
    def detect_and_send_warning_to_inactive_tutors
      Tutor.inactive_long_enough_to_warn_to_leave.each do |tutor|
        Mailer.send_mail_at Time.current.change(hour: 8, min: 0), :being_locked, tutor
        logger.info "Sent warning mail to tutor #{tutor.id}."
      end
    end

    # 時間単位基本報酬改定ポイントを持っているチューターを、ポイントを消費して時給を上げる
    def upgrade_tutors_with_upgrade_points
      Tutor.has_upgrade_points.each do |tutor|
        tutor.upgrade(true)
      end
    end

    def clear_lesson_skip_counts
      Tutor.only_active.each do |tutor|
        tutor.clear_lesson_skip_count
      end
    end

    def recent_lessons_count
      50
    end

    def only_regular
      joins(:info).where("tutor_infos.status = 'regular'")
    end

    def undertake_group_lesson
      joins(:info).where("tutor_infos.undertake_group_lesson = 1")
    end

    def has_upgrade_points
      joins(:info).where('tutor_infos.upgrade_points > 0')
    end

    def only_special
      where(type: 'SpecialTutor')
    end

    def for_list
      includes(:info, :price)
    end

    def inactive_for_long
      inactive_for_days (SystemSettings.tutor_max_absent_days / 2)
    end

    def inactive_long_enough_to_leave
      inactive_for_days SystemSettings.tutor_max_absent_days
    end

    def inactive_long_enough_to_warn_to_leave
      d = SystemSettings.tutor_warning_absent_days.days.ago
      range = d.beginning_of_day .. d.end_of_day
      only_active.where(last_request_at: range)
    end

    private

    def inactive_for_days(days)
      t = days.days.ago.beginning_of_day
      only_active.where('(last_request_at IS NULL AND created_at < :t) OR (last_request_at < :t)', t: t)
    end
  end

  searchable auto_index: false do
    integer :tutor_id, using: :id
    time    :created_at
    boolean :active, using: :active?
    boolean :locked, using: :locked?
    boolean :left,   using: :left?
    string :status do
      info.status
    end

    text :user_name
    text :full_name
    text :full_name_kana
    text :nickname

    integer :organization_id
    boolean :regular, using: :regular?

    string :sex
    text :emails
    text :skype_id
    text :phone_number
    integer :age_group_id
    integer :age
    date :birthday

    text :address do
      current_address && current_address.serialize
    end
    text :hometown_address do
      hometown_address && hometown_address.serialize
    end

    boolean :graduated, using: :graduated?
    text :college
    text :department
    text :faculty
    text :graduate_college
    text :graduate_college_department
    text :major
    text :birth_place
    text :high_school
    text :pc_model_number

    text :hobby
    text :activities
    text :teaching_experience
    text :teaching_results
    text :free_description

    integer :subject_ids, :multiple => true do
      teaching_subjects.map(&:subject_id)
    end
    integer :weekdays, :multiple => true do
      available_weekdays
    end
    boolean :undertake_group_lesson, using: :undertake_group_lesson?
    boolean :special, using: :special?

    double :average_cs_points
    double :cs_points

    integer :base_lesson_fee
    integer :lesson_fee, using: :base_lesson_fee
    integer :lesson_fee_0
    integer :lesson_fee_50
    integer :lesson_fee_100
    integer :lesson_fee_200

    integer :lesson_units, using: :total_lesson_units
    integer :cancellation_count do
      lesson_cancellations.count
    end
    integer :weekday_schedules_count
    text :jyuku_history
    text :favorite_books
    # 紹介者
    text :reference_user_name
  end

  scope :special, where(type: 'SpecialTutor')

  has_many :lessons, :dependent => :nullify # レッスンは残す
  has_one :app_form, class_name:TutorAppForm.name, :dependent => :destroy
  has_one :info, class_name:TutorInfo.name, :validate => true, :autosave => true, :dependent => :destroy
  has_many :weekday_schedules, :dependent => :delete_all
  has_many :available_times, order: 'start_at', :dependent => :delete_all
  has_many :daily_available_times, class_name: TutorDailyAvailableTime.name, order: 'start_at', dependent: :delete_all
  has_and_belongs_to_many :subjects, :uniq => true
  has_many :unavailable_days, :dependent => :delete_all
  has_many :basic_lesson_infos, conditions:"status != 'new'", :dependent => :nullify # レッスンは残す
  has_many :optional_lessons # lessonsに含まれるので:dependentは指定しない。
  has_one  :price, class_name:TutorPrice.name, :dependent => :destroy, :autosave => true
  has_one :current_address, :as => :addressable, :dependent => :destroy, :autosave => true
  has_one :hometown_address, :as => :addressable, :dependent => :destroy, :autosave => true
  has_many :teaching_subjects, :dependent => :destroy
  has_many :subject_levels, :through => :teaching_subjects, :uniq => true
  has_many :daily_lesson_skips, class_name:TutorDailyLessonSkip.name, :dependent => :destroy
  has_many :tutor_students, :dependent => :destroy
  has_many :students, :through => :tutor_students, :uniq => true
  has_many :student_favorite_tutors, :dependent => :delete_all
  has_many :students_favored_by, :through => :student_favorite_tutors, :source => :student
  has_many :student_lesson_tutors, :dependent => :delete_all
  has_many :lesson_students, :through => :student_lesson_tutors, :source => :student, :uniq => true

  has_many :monthly_incomes, class_name: TutorMonthlyIncome.name

  # 会計科目
  has_many :tutor_referral_fees, class_name:Account::TutorReferralFee.name, :as => :owner

  attr_accessor :anytime_available

  validates_presence_of :email, :info, :nickname
  validate :check_not_leaving_with_unfinished_lessons
  validates_format_of :email, :with => Tutor.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?
  validates_uniqueness_of :nickname, allow_blank: true, message: :taken

  before_validation :clear_empty_addresses

  before_save do
    if info && address.blank?
      self.address = info.current_address
    end
    if reference_user_name
      TutorReferenceService.new(self).assign_reference(reference_user_name)
    end
  end

  before_create do
    self.status = 'active'
    self.price = TutorPrice.new_default_price if price.blank?
  end

  after_create do
    Mailer.send_mail_async(:tutor_created, self, password)
  end

  after_create :create_document_camera

  #
  # TutorInfoへのDelegation
  #
  delegate :college,
           :department,
           :faculty,
           :graduate_college,
           :graduate_college_department,
           :major,
           :high_school,
           :hobby,
           :activities,
           :teaching_experience,
           :teaching_results,
           :free_description,
           :jyuku_history,
           :favorite_books,
           :total_lesson_units,
           :graduated?,
           :undertake_group_lesson?,
           :average_cs_points,
           :cs_points,
           :cs_points_of_recent_lessons,
           :total_lesson_units,
           to: :info

  delegate :lesson_unit_fee_for_grade,
           :lesson_fee_0,
           :lesson_fee_50,
           :lesson_fee_100,
           :lesson_fee_200,
           to: :price

  #
  # Instance methods
  #

  def beginner?
    info.new?
  end

  def special?
    false
  end

  # 本登録チューターであればtrueを返す。
  # そうでなければfalseを返す
  def regular?
    info.regular?
  end

  def teaching_level(grade_group, subject)
    teaching_subject = teaching_subjects.where(grade_group_id:grade_group.id, subject_id:subject.id).first
    teaching_subject ? teaching_subject.level : 0
  end

  def teaching_level_of_subject(subject)
    teaching_subject = teaching_subjects.where(subject_id: subject.id).first
    teaching_subject ? teaching_subject.level : 0
  end

  def root_path
    tu_root_path
  end

  def nickname2
    @nickname2 ||= display_nickname
  end

  def display_nickname
    m = Regexp.new(I18n.t('tutor.nickname_pattern')).match(nickname)
    if m
      nickname
    else
      I18n.t('tutor.nickname_format', nickname: nickname)
    end
  end

  ###########################################################
  # 状態変化
  ###########################################################

  # チューターを仮登録から本登録にする
  def become_regular!
    if beginner?
      transaction do
        info.become_regular!
        on_become_regular
        logger.account_log("BECOME_REGULAR", attributes)
      end
    end
  end

  def become_regular
    become_regular!
    true
  rescue Exception => e
    logger.error e
    false
  end

  def become_regular_if_condition_satisfied
    if beginner?
      if condition_to_be_regular_satisfied?
        become_regular!
      end
    end
  end

  def can_become?(tutor_type)
    case tutor_type
    when 'RegularTutor'
      can_become_regular_tutor?
    when 'BeginnerTutor'
      can_become_beginner_tutor?
    when 'SpecialTutor'
      can_become_special_tutor?
    else
      false
    end
  end

  def can_become_regular_tutor?
    !regular?
  end

  def can_become_beginner_tutor?
    !beginner? && !condition_to_be_regular_satisfied?
  end

  def can_become_special_tutor?
    !special?
  end

  def condition_to_be_regular_satisfied?
    total_lesson_units >= 10 && cs_sheets.with_good_score.count >= 2
  end

  def change_type(tutor_type)
    case tutor_type
    when 'BeginnerTutor'
      if can_become_beginner_tutor?
        become_beginner
      else
        errors.add :type, :cannot_become_beginner
        false
      end
    when 'SpecialTutor'
      if can_become_special_tutor?
        become_special_tutor.errors.empty?
      else
        errors.add :type, :cannot_become_special
        false
      end
    when 'RegularTutor'
      if can_become_regular_tutor?
        become_regular
      else
        errors.add :type, :cannot_become_regular
        false
      end
    end
  end

  def become_special_tutor
    transaction do
      info.become_regular
      update_column :type, SpecialTutor.name
      tutor = SpecialTutor.find id
      Sunspot.remove self
      Sunspot.index tutor
      Sunspot.commit
      tutor
    end
  end

  def become_normal_tutor
    transaction do
      info.become_normal
      update_column :type, Tutor.name
      tutor = Tutor.find id
      Sunspot.remove self
      Sunspot.index tutor
      Sunspot.commit
      tutor
    end
  end

  def become_beginner
    false if beginner?
    transaction do
      info.become_beginner
      self.type = Tutor.name
      save!
      price.reset!
      true
    end
  rescue => e
    logger.error e
    false
  end

  # チューターを除籍処分にする
  def expel!
    # TODO:実装内容は未確定
    logger.account_log("TUTOR_EXPELLED", log_attributes)
  end

  def upgrade(use_all=false)
    info.upgrade(use_all)
  end

  # 担当授業が前後15分以内に存在しなければtrueを返す
  def available?(time_range, student=nil)
    if anytime_available
      true
    else
      t1 = Lesson.min_interval.minutes.ago(time_range.first)
      t2 = Lesson.min_interval.minutes.since(time_range.last)
      if basic_lesson_infos.overlap_with(t1, t2).any?
        false
      elsif lessons.overlap_with(t1, t2).any?
        false
      else
        true
      end
    end
  end

  def have_time_for_lesson?(lesson)
    lessons.conflict_with(lesson, Lesson.min_interval).any?
  end

  def has_bank_account?
    yucho_account.present? && mitsubishi_tokyo_ufj_account.present?
  end

  def cs_sheets
    CsSheet.joins(:lesson).where(lessons:{tutor_id:id})
  end

  def bs_users
    BsUser.where(organization_id:organization_id)
  end

  def bss
    Bs.scoped()
  end

  # アクセス可能なすべてのレッスンレポートを返す
  def lesson_reports
    # 自分が書いたもの＋現在担当している生徒に関するもの
    LessonReport.where('author_id=? OR student_id IN (?)', id, student_ids)
  end

  def search_lesson_reports(key, options={})
    # アクセスできる生徒のレポートに限定する
    super(key, options.merge(student_ids:student_ids))
  end


  # 3ヶ月後の月末までデータを埋める
  def update_available_times
    transaction do
      AvailableTime.delete_all(tutor_id:self.id)
      schedules = weekday_schedules.group_by(&:wday)
      wdays = schedules.keys
      excludes = unavailable_days.map(&:date)
      first_day = Date.today
      last_day  = 3.months.since(first_day).end_of_month
      days = (first_day .. last_day).select{|d| wdays.include?(d.wday) && !excludes.include?(d)}
      days.each do |day|
        schedules[day.wday].each do |schedule|
          AvailableTime.create! do |t|
            t.tutor = self
            t.start_at = Time.zone.local(day.year, day.month, day.day, schedule.start_time.hour, schedule.start_time.min)
            t.end_at = schedule.duration.minutes.since(t.start_at)
          end
        end
      end
    end
  end

  def registered_day
    created_at.to_date
  end

  #################################################################
  # レッスン
  #################################################################

  def lesson_requests
    lessons.future.under_request.order(:start_time)
  end

  # 担当しているすべてのベーシックレッスンの曜日ごとのスケジュールを返す
  def basic_lesson_weekly_schedules
    BasicLessonWeekdaySchedule.of_tutor(self)
  end

  def accept_lesson(lesson)
    if lesson && lesson.tutor == self
      lesson.accept!
    end
  end

  def next_lesson_of(lesson)
    lessons.after(lesson.end_time).order("start_time").first
  end

  def unfinished_lessons
    lessons.unfinished
  end

  def should_write_lesson_report?(lesson, student)
    if lesson.aborted?
      false
    elsif lesson.done?
      true
    else
      lesson.started? && Time.now > lesson.end_time
    end
  end

  def lesson_cancellations
    TutorLessonCancellation.joins(:lesson).where(lessons: {tutor_id: id})
  end

  #################################################################
  # イベント
  #################################################################

  # レッスンが終了した時に呼び出される。
  # 1つのレッスンに付き1度だけ呼ばれる。
  def on_lesson_done(lesson)
    if lesson.done? && lesson.tutor == self
      # 消化した単位数を更新する
      # 消化した単位数が88の倍数になると昇給ポイントがアップする
      info.increment!(:total_lesson_units, lesson.units)
      # 条件を満たしていると本登録となる
      become_regular_if_condition_satisfied if beginner?

      # ベーシックレッスン終了時固有の処理
      if lesson.is_a?(BasicLesson)
        # ベーシックレッスンの連続実行記録の更新
        # 規定の回数に達すると昇給ポイントがアップする
        info.increment!(:continuous_basic_lesson_count)
      end
    end
  end

  # チューターがレッスンをすっぽかしたときの処理
  def on_lesson_skipped(lesson)
    if lesson.tutor == self
      info.increment!(:lesson_skip_count)
      daily_lesson_skips.find_or_create_by_date(lesson.date).increment!(:count)
    end
  end

  # レッスンをすっぽかした回数（日数ではなく）
  def lesson_skip_count
    daily_lesson_skips.total_count
  end

  # レッスンをすっぽかした記録を削除する
  def clear_lesson_skip_count
    daily_lesson_skips.destroy_all
  end

  # レッスンから外された時にLessonから呼ばれる
  def on_taken_off_lesson(lesson)
    if lesson.is_a?(BasicLesson)
      # ペナルティとして連続ベーシックレッスンのカウントをクリアする
      info.continuous_basic_lesson_count = 0
    end
  end

  def on_cs_sheet_created(cs_sheet)
    if cs_sheet.tutor?(self)
      info.on_cs_sheet_created(cs_sheet)
      become_regular_if_condition_satisfied if beginner?
    end
  end

  # レッスンのCSポイントが確定したときに呼ばれる
  def on_lesson_score_settled(lesson)
    TutorCsPointService.new(self).update!
    Sunspot.index! self
  end

  def on_weekday_schedules_changed
    # do nothing
  end

  def on_daily_available_times_updated
    Mailer.send_mail(:favorite_tutor_weekday_schedules_changed, self)
  end

  ### 予定設定

  def add_weekday_schedule(start_time, end_time, options={})
    wday = options[:wday] || start_time.wday
    weekday_schedules.create!(wday:wday, start_time:start_time, end_time:end_time)
  end

  # このチューターがレッスンをできる曜日
  def available_weekdays
    wdays = weekday_schedules.map(&:wday).uniq
    if wdays.present?
      wdays.sort
    else
      (0..6).to_a # 全曜日
    end
  end


  ################################################################
  # 権限
  ################################################################

  def can_cancel?(lesson)
    lesson.cancellable_by_tutor?
  end

  def can_cancel_more?(lesson)
    if lesson.optional?
      can_cancel_optional_lesson_for_month? lesson.start_time
    elsif lesson.basic?
      can_cancel_basic_lesson_for_month? lesson.start_time
    else
      false
    end
  end

  ################################################################
  # 設定値
  ################################################################

  def optional_lesson_cancellation_limit_per_month
    2
  end

  def basic_lesson_cancellation_limit_per_month
    1
  end

  ################################################################

  def refresh_contact_list
    # ベーシックレッスンを現在も担当している生徒だけを残す
    id_list = basic_lesson_infos.only_current.select(:id)
    students = Student.joins(:basic_lesson_students).where(basic_lesson_students:{basic_lesson_info_id:id_list})
    self.contact_list = students
    save
  end

  def can_undertake_lesson?
    if regular?
      true
    else
      beginner_lesson_requests_limit > 0
    end
  end

  def can_enter_lesson?(lesson)
    if lesson.can_open?
      if lesson.period_to_enter_for?(self)
        true
      else
        lesson.entered?(self) && lesson.have_active_students?
      end
    else
      false
    end
  end

  def beginner_tutor_remaining_lesson_count
    BeginnerTutorService.new(self).remaining_lessons_count
  end

  def beginner_lesson_requests_limit
    BeginnerTutorService.new(self).lesson_requests_limit
  end

  def unreceived_cs_sheets_count
    lessons.only_done.inject(0){|sum, lesson| lesson.unreceived_cs_sheets_count + sum}
  end

  # チューターのCSポイントを計算する
  # @param count: カウントする直近のレッスン数。未指定の場合は全レッスンから計算する
  def calculate_cs_points(count=nil)
    if count
      lessons.with_cs_point.order('start_time DESC').limit(count).select(:cs_point).inject(0){|sum, lesson| lesson.cs_point + sum}
    else
      lessons.sum(:cs_point)
    end
  end

  private

    def on_leaving
      transaction do
        # 自分が担当している授業をすべてキャンセルする。
        lessons.future.each do |lesson|
          lesson.cancel_by_tutor(I18n.t('tutor_lesson_cancellation.because_of_leaving'))
        end
      end
    end

    def on_left
      super
      Mailer.send_mail :membership_cancelled, self
    end

    def clear_empty_addresses
      if current_address
        if current_address.empty?
          self.current_address = nil
        end
      end
      if hometown_address
        if hometown_address.empty?
          self.hometown_address = nil
        end
      end
    end

    def on_become_regular
      price.reset!
      TutorReferenceService.new(self).pay
      Mailer.send_mail(:tutor_become_regular, self)
    end

    def check_not_leaving_with_unfinished_lessons
      if active_changed? && !active
        if unfinished_lessons.any?
          errors.add :unfinished_lessons, :remaining
        end
      end
    end

    def create_mail(mail_type, *args)
      TutorMailer.send mail_type, self, *args
    end

end

#SpecialTutor # load subclasses

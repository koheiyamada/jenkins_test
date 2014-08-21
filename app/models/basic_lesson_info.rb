class BasicLessonInfo < ActiveRecord::Base
  include Searchable
  include BasicLessonsHelper
  include UsersHelper
  include LessonsHelper

  MAX_STUDENTS = 2 # TODO: externalize this

  searchable auto_index: false do
    text :tutor_full_name do
      tutor && tutor.full_name
    end
    text :tutor_nick_name do
      tutor && tutor.nickname
    end
    integer :wdays, :multiple => true do
      schedules.map(&:wday)
    end
    time :start_times, :multiple => true do
      schedules.map(&:start_time)
    end
    integer :start_time_hours, :multiple => true do
      schedules.map{|schedule| schedule.start_time.hour}
    end
    boolean :active do
      active?
    end
    boolean :shared_lesson do
      shared_lesson?
    end
    boolean :friends_lesson do
      friends_lesson?
    end
    boolean :single_lesson do
      !(shared_lesson? || friends_lesson?)
    end
    boolean :has_multiple_schedules do
      schedules.count > 1
    end
    boolean :full do
      full?
    end
    integer :student_ids, :multiple => true do
      student_ids
    end
  end

  class << self
    def overlap_with(start_at, end_at)
      range = BasicLessonWeekdaySchedule.new(start_time:start_at, end_time:end_at)
      includes(:schedules).where("basic_lesson_weekday_schedules.start_time < :end_time AND basic_lesson_weekday_schedules.end_time > :start_time", start_time:range.start_time, end_time:range.end_time)
    end

    def created_by(user)
      where(creator_id:user.id)
    end

    # レッスンと時間がかぶるという条件で絞込み
    def conflict_with(lesson, tolerance=0)
      t1 = tolerance.minutes.ago(lesson.start_time)
      t2 = tolerance.minutes.since(lesson.end_time)
      range = WeekdayTimeRange.new(start_time: t1, end_time: t2)
      includes(:schedules).where('basic_lesson_weekday_schedules.start_time < :end_time AND basic_lesson_weekday_schedules.end_time > :start_time',
                                 start_time: range.start_time,
                                 end_time: range.end_time)
    end

    def conflict_with_basic_lesson(basic_lesson_info, tolerance=0)
      schedules = basic_lesson_info.schedules
      condition = (['(basic_lesson_weekday_schedules.start_time < ? AND basic_lesson_weekday_schedules.end_time > ?)'] * schedules.count).join(' OR ')
      params = schedules.map{|schedule|
        [tolerance.minutes.since(schedule.end_time),
         tolerance.minutes.ago(schedule.start_time)]
      }.flatten
      includes(:schedules).where(condition, *params)
    end

    # チューターが月にベーシックレッスンの日程を変更できる回数
    def monthly_tutor_schedule_change_limit
      1
    end

    # すべてのベーシックレッスンに4ヶ月先までのレッスンデータを供給する
    def supply_lessons
      BasicLessonInfo.only_active.continuing.each do |basic_lesson_info|
        basic_lesson_info.supply_lessons
      end
    end

    # 4ヶ月先までのレッスンデータの補充と、今月分の支払の確定処理
    def extend!(year, month)
      basic_lesson_infos = BasicLessonInfo.only_active.continuing
      basic_lesson_infos.each do |basic_lesson_info|
        basic_lesson_info.extend!(year, month)
      end
      logger.info "#{basic_lesson_infos.count} basic lessons are extended successfully."
    rescue ActiveRecord::RecordInvalid => e
      logger.error e
      SystemAdminMailer.error_happened('BasicLessonInfo.extend!', e)
    end

    # 時間衝突の判定対象となる状態のリスト（チューター向け）
    def fixed_statuses
      %w(active)
    end

    # 時間衝突の判定対象となる状態のリスト（生徒向け）
    def fixed_statuses_for_students
      %w(pending_approval active)
    end

    def for_list
      includes(:tutor, :students, :schedules)
    end

    # 申し込み中のレッスンで、レッスンと時間帯が衝突し得るものを返す
    def conflictable_with_lesson(lesson)
      time = DateUtils.prev_cutoff_datetime(lesson.start_time)
      pending.where('basic_lesson_infos.created_at < ?', time).conflict_with(lesson, Lesson.min_interval)
    end

    private

      def settle_payments_of_month(year, month)
        BasicLesson.of_settlement_month(year, month).each do |basic_lesson|
          basic_lesson.establish
        end
      end
  end

  belongs_to :tutor
  belongs_to :subject
  has_many :basic_lesson_students, :dependent => :destroy
  has_many :students, :through => :basic_lesson_students, :uniq => true
  has_many :lessons, class_name:BasicLesson.name, :foreign_key => :course_id, :dependent => :destroy
  belongs_to :creator, class_name:User.name
  has_many :schedules, class_name:BasicLessonWeekdaySchedule.name
  has_many :monthly_stats, class_name:BasicLessonMonthlyStat.name
  has_many :basic_lesson_possible_students
  has_many :possible_students, :through => :basic_lesson_possible_students, :source => :student, :uniq => true

  accepts_nested_attributes_for :schedules, :reject_if => :all_blank, :allow_destroy => true

  attr_accessible :schedules_attributes
  attr_accessible :end_time, :start_time, :units, :wdays, :creator
  attr_accessible :final_day, :as => :admin
  serialize :wdays, Array

  scope :pending, where(status: 'pending_approval')
  scope :rejected, where(status: 'rejected')
  scope :fixed, where(status: fixed_statuses)
  scope :fixed_for_student, where(status: fixed_statuses_for_students)
  scope :closed, where(status: 'closed')
  scope :not_closed, where('basic_lesson_infos.status != ?', 'closed')
  scope :incomplete, where('basic_lesson_infos.status != ?', 'active')
  scope :only_complete, where(status:'active')
  scope :only_active, where(status: 'active')
  scope :only_current, lambda{where(status: 'active').where('final_day IS NULL OR final_day >= :d', d: Date.today)}
  scope :continuing, where(auto_extension: true)
  scope :shared, where(type: 'SharedBasicLessonInfo')

  validates_presence_of :tutor, :students, :if => :fixed?
  validates_length_of :schedules, :minimum => 1, :message => :at_least_one, :if => :fixed?
  validate :at_least_one_students_required, :if => :fixed?
  validate :does_not_conflict_with_other_basic_lessons, :if => :have_schedules?
  validate :does_not_conflict_with_optional_lessons, :if => :have_schedules?
  validates_inclusion_of :status, :in => %w(new pending_approval rejected active closed)
  validate :schedules_not_overwrap
  validate :final_day_must_be_future_or_nil
  validate :ensure_not_closed, if: :enabling_auto_extension?

  ###########################################################################
  # フック
  ###########################################################################
  after_update do
    if status_changed?
      if active?
        tutor.students += students
        Mailer.send_mail(:basic_lesson_info_activated, self)
      end
    end
  end

  before_update :on_closing, if: :closing?
  after_update  :on_closed, if: :closing?


  ###########################################################################
  # 授業データ作成
  ###########################################################################

  #
  # 作成に失敗した場合も継続する。
  #
  def create_lessons(from_date, to_date)
    schedules.flat_map{|schedule| create_lessons_for_schedule(schedule, from_date, to_date)}
  end

  def create_lessons_for_schedule(schedule, from_date, to_date)
    days = (from_date .. to_date).to_a.select{|d| d.wday == schedule.wday}
    created_lessons = days.map do |day|
      create_lesson_of_schedule(schedule, day)
    end
    succeeded, failed = created_lessons.partition{|l| l.persisted?}
    failed.each do |lesson|
      logger.warn "Failed to create basic lesson for #{id} because #{lesson.errors.full_messages}"
      logger.warn lesson.attributes
    end
    succeeded
  end

  def create_lesson_of_schedule(schedule, day)
    start_time = Time.new(day.year, day.month, day.day, schedule.hour, schedule.min)
    lessons.create(start_time: start_time, units: schedule.units)
  end

  def create_lessons_of_month!(year, month, count=1)
    m1 = Date.new(year, month)
    m2 = (count - 1).months.since(m1)
    from_date = m1.beginning_of_month
    to_date   = m2.end_of_month
    create_lessons(from_date, to_date)
  end

  def extend_months(months=1)
    transaction do
      months.times do
        month = next_month_to_add_lessons
        create_lessons_of_month!(month.year, month.month)
      end
    end
  end

  # ベーシックレッスンを延長する。
  # 4ヶ月先までのレッスンデータを作成し、
  # year, monthで指定した月の翌月分の授業を確定する。
  def extend!(year, month)
    d = last_lesson_date ? last_lesson_date.next_day : nil
    supply_lessons(d)
    settle_payment_of_month(year, month)
    logger.lesson_log('BASIC_LESSON_EXTENDED', attributes)
  end

  def last_lesson
    Lesson.where(course_id:id).order('start_time DESC').first
  end


  # 存在するレッスンデータのうち、日付上最後のものの日にちを返す。
  def last_lesson_date
    lesson = last_lesson
    lesson.present? ? lesson.date : nil
  end

  # 4ヶ月先までのレッスンを作成する
  # @param from:Date （オプション）ここで指定した日以降のレッスンデータを登録する
  def supply_lessons(from = nil)
    from ||= supply_start_date
    to = DateUtils.cutoff_date_of_month(4.months.from_now)
    create_lessons(from, to)
  end

  def supply_start_date
    if Date.today.day <= SystemSettings.cutoff_date
      DateUtils.cutoff_date_of_month(Date.today).next_day
    else
      DateUtils.cutoff_date_of_month(Date.today.next_month).next_day
    end
  end

  # 授業を指定した月で終了とする。
  # レッスンは締め日までとなる。
  # 指定された月が現在よりも以前の場合は何もしない。
  # 指定された月が当月の場合、締め日前であれば終了処理をする。締め日以後であれば何もしない。
  # 指定された月が当月以降の場合は終了処理をする。
  def stop_in_month(year, month)
    month = Date.new(year, month)
    today = Date.today
    current_month = Date.new(today.year, today.month)
    if month < current_month
      false
    elsif month == current_month
      if today.day <= SystemSettings.cutoff_date
        close_at(DateUtils.cutoff_date_of_month(month)).tap do
          puts errors.full_messages
        end
      else
        false
      end
    else
      close_at(DateUtils.cutoff_date_of_month(month))
    end
  end

  #################################################################
  ### 状態
  #################################################################

  def new?
    status == 'new'
  end

  def fixed?
    status != 'new'
  end

  def active?
    status == 'active'
  end

  def pending?
    status == 'pending_approval'
  end

  def rejected?
    status == 'rejected'
  end

  def closed?
    status == 'closed'
  end

  # これ以上生徒を追加できなければtrue
  def full?
    basic_lesson_students.length >= max_students_count
  end

  def max_students_count
    1
  end

  def min_students_count
    1
  end

  def have_enough_students?
    students.length >= min_students_count
  end

  def group_lesson?
    students.length > 1
  end

  def friends_lesson?
    false
  end

  def shared_lesson?
    false
  end

  def multi_student_lesson?
    friends_lesson? || shared_lesson?
  end

  def can_have_multiple_students?
    false
  end

  def style
    :single
  end

  def have_schedules?
    schedules.present?
  end

  def lesson_time_changable?(lesson)
    if lesson.is_a?(BasicLesson) && lesson.course == self
      month = lesson.original_start_time
      monthly_stats_for(month.year, month.month).tutor_schedule_change_count < monthly_tutor_schedule_change_limit
    else
      false
    end
  end

  #################################################################
  ### 状態変化
  #################################################################

  def submit_to_tutor
    self.status = 'pending_approval'
    save
  end

  def accept
    if pending? || new?
      activate!
      touch(:tutor_accepted_at)
      on_accepted
      logger.lesson_log('BASIC_LESSON_ACCEPTED_BY_TUTOR', attributes)
    end
  end

  def accept_and_supply_lessons
    transaction do
      accept
      delay.supply_lessons
    end
  end

  def reject
    if pending?
      update_attribute(:status, 'rejected')
      touch(:tutor_rejected_at)
      on_rejected
      logger.lesson_log('BASIC_LESSON_REJECTED_BY_TUTOR', attributes)
    end
  end

  def activate!
    unless active?
      self.status = 'active'
      resolve_start_day
      save!
      # チューターと生徒のコンタクトリストを更新する
      tutor.contact_list << students
      students.each do |student|
        student.contact_list << tutor
      end
      # 最初の授業データを作成する
      #extend_months
    end
  end

  def activate_and_supply_lessons!
    transaction do
      activate!
      supply_lessons
    end
  end

  # 作成を中止する
  def cancel
    if fixed?
      if pending?
        destroy
        true
      else
        false
      end
    else
      destroy
      true
    end
  end

  # レッスン終了日を確定する
  def close_at!(date, options={})
    options = {force:false}.merge(options)
    remaining_lessons = lessons.after(date.end_of_month)
    if remaining_lessons.present?
      if options[:force]
        remaining_lessons.each do |lesson|
          lesson.cancel
        end
        update_attributes({final_day:date}, :as => :admin)
      elsif block_given?
        yield self
      else
        raise 'Failed to close this basic lesson because there are lessons held after the given date.'
      end
    else
      update_attributes({final_day:date}, :as => :admin)
    end
  end

  # このベーシックレッスンを完了する。
  # 残っているレッスンはすべてキャンセルされる。
  # 自動延長はオフになる。
  def close
    self.status = 'closed'
    self.auto_extension = false
    self.final_day = Date.today
    save(validate: false)
  end

  def closing?
    status == 'closed' && status_was != 'closed'
  end

  def on_closing
    cancel_future_lessons
  end

  def on_closed
    Mailer.send_mail(:basic_lesson_info_closed, self)
  end

  # 現在以降のレッスンをすべてキャンセルする
  def cancel_future_lessons
    lessons.after(Time.current).cancel_all
  end

  def turn_off_auto_extension
    self.auto_extension = false
    self.final_day = resolve_final_day
    save
  end

  def turn_on_auto_extension
    self.auto_extension = true
    self.final_day = nil
    save
  end

  def resolve_final_day(time = Time.current)
    if time.day > SystemSettings.cutoff_date
      time.next_month.end_of_month.to_date
    else
      time.end_of_month.to_date
    end
  end

  def student_acceptable?(student)
    students.empty?
  end

  def add_student(student)
    basic_lesson_student = basic_lesson_students.create(student: student)
    if basic_lesson_student.persisted?
      # 既存のレッスンに追加する
      add_student_to_lessons(student)

      # Solrのインデックスを更新する（fullフラグの更新が主目的）
      # 関連が追加されるだけでは自動的にSolrのインデックスを更新してくれないようなので、
      # ここで明示的にインデックスの更新処理を入れている。
      Sunspot.index! self
    end
    basic_lesson_student
  end

  def add_student_to_lessons(student)
    if basic_lesson_student(student).present?
      start_day = (Time.current.day > SystemSettings.cutoff_date ? 2 : 1).months.from_now.beginning_of_month
      lessons.where('start_time >= ?', start_day).each do |lesson|
        lesson.add_student(student)
      end
      self
    end
  end

  def basic_lesson_student(student)
    basic_lesson_students.where(student_id: student.id).first
  end

  ##################################################
  # ユーティリティ プロパティ
  ##################################################
  def description
    "#{tutor.nickname} " + schedules.map(&:description).join(',')
  end

  def final_month
    final_day && final_day.prev_month
  end

  def subject_name
    subject && subject.name
  end

  def student_emails
    students.map(&:email)
  end

  def max_min_lesson_units
    students.map(&:min_lesson_units).max || 1
  end

  def organization_emails
    students.map(&:organization_emails).flatten.uniq
  end

  def tutor_full_name
    tutor && tutor.full_name
  end

  def tutor_nickname
    tutor && tutor.nickname
  end

  #################################################################
  # 他のモデルからの通知
  #################################################################
  def on_schedule_changed(schedule)
    return unless schedule.basic_lesson_info == self

    # レッスンの時間を変更する

  end

  def on_lesson_time_changed(lesson)
    if lesson.is_a?(BasicLesson) && lesson.course == self
      month = lesson.original_start_time
      stats = monthly_stats_for(month.year, month.month)
      stats.increment!(:tutor_schedule_change_count)
      touch(:schedule_changed_at)
    end
  end

  def on_lesson_tutor_changed(lesson)
    if lesson.is_a?(BasicLesson) && lesson.course == self
      touch(:tutor_changed_at)
    end
  end

  ##################################################
  # 統計
  ##################################################
  def monthly_stats_for(year, month)
    monthly_stats.find_or_create_by_year_and_month(year, month)
  end

  ##################################################
  # 会計
  ##################################################
  def settle_payment_of_month(year, month)
    lessons.of_settlement_month(year, month).each do |lesson|
      unless lesson.establish
        logger.info "Lesson #{lesson.id} is not established because #{lesson.errors.full_messages}"
      end
    end
  end

  private
    # 終了日を確定する。
    # その日以降のレッスンは削除される
    def close_at(date)
      transaction do
        lessons.after(date.end_of_day).destroy_all
        self.final_day = date
        save
      end
    end

    def resolve_start_day
      if start_day.blank?
        if Date.today.day > SystemSettings.cutoff_date
          self.start_day = Date.today.months_since(2).beginning_of_month
        else
          self.start_day = Date.today.months_since(1).beginning_of_month
        end
      end
    end

    ### 検証用メソッド群

    # 曜日の日程がかぶっていないか検証する
    def schedules_not_overwrap
      if schedules.length > 1 && schedules.combination(2).any?{|s1, s2| s1.conflict?(s2)}
        errors.add(:schedules, :conflict_with_each_other)
      end
    end

    def at_least_one_students_required
      unless students.length > 0
        errors.add(:students, :at_least_one)
      end
    end

    def tutor_schedule_available?
      if tutor && !tutor.anytime_available
        schedules.each do |schedule|
          if tutor.weekday_schedules.all?{|weekday_schedule| !weekday_schedule.include?(schedule)}
            errors.add(:schedules, :does_not_match_with_tutor_schedules)
          end
        end
      end
    end

    # 他のベーシックレッスンとの衝突判定をする
    # チューターと受講者のそれぞれについて、個別に判定する。
    #
    def does_not_conflict_with_other_basic_lessons
      schedules.each do |schedule|
        if tutor.present?
          tutor.conflicting_basic_lesson_schedules(schedule).each do |conflicting_schedule|
            errors.add(:schedules,
                       :conflict_with_basic_lesson_schedules_of_tutor,
                       basic_lesson: basic_lesson_schedule_for_tutor(conflicting_schedule))
          end
        end
        students.each do |student|
          student.conflicting_basic_lesson_schedules(schedule).each do |conflicting_schedule|
            errors.add(:schedules,
                       :conflict_with_basic_lesson_schedules_of_student,
                       basic_lesson: basic_lesson_schedule_for_student(conflicting_schedule))
          end
        end
      end
    end

    def does_not_conflict_with_optional_lessons
      t = confliction_time_threshold
      schedules.each do |schedule|
        if tutor.present?
          tutor.optional_lessons.only_fixed.after(t)
          .select{|lesson| schedule.conflict_with_lesson?(lesson, Lesson.min_interval)}.each do |lesson|
            errors.add(:schedules,
                       :conflict_with_optional_lesson_of_tutor,
                       lesson: lesson_schedule_for_student(lesson))
          end
        end
        students.each do |student|
          student.optional_lessons.fixed_for_student(student).after(t)
          .select{|lesson| schedule.conflict_with_lesson?(lesson, Lesson.min_interval)}.each do |lesson|
            errors.add(:schedules,
                       :conflict_with_optional_lesson_of_student,
                       lesson: lesson_schedule_for_student(lesson))
          end
        end
      end
    end

    def confliction_time_threshold
      t = DateUtils.next_cutoff_datetime(created_at || Time.current)
      now = Time.current
      t > now ? t : now
    end

    def next_month_to_add_lessons
      if Lesson.where(course_id:id).empty?
        DateUtils.n_months_later(Date.today.day <= SystemSettings.cutoff_date ? 1 : 2)
      else
        1.month.since(last_lesson.start_time)
      end
    end

    def monthly_tutor_schedule_change_limit
      BasicLessonInfo.monthly_tutor_schedule_change_limit
    end

    def final_day_must_be_future_or_nil
      if final_day
        if final_day < Date.today
          errors.add :final_day, :must_be_today_or_future
        end
      end
    end

    def check_tutor_is_regular
      if tutor && !tutor.regular?
        errors.add(:tutor, :must_be_regular)
      end
    end

    def on_accepted
      Mailer.send_mail(:basic_lesson_info_accepted, self)
      # 時間がかぶっている申込中のレッスンを拒否する
      tutor.basic_lesson_infos.pending.conflict_with_basic_lesson(self, Lesson.min_interval).each do |basic_lesson_info|
        basic_lesson_info.reject
      end
      connect_tutor_and_students
    end

    def on_rejected
      Mailer.send_mail(:basic_lesson_info_rejected, self)
    end

    def connect_tutor_and_students
      students.each do |student|
        if tutor.present?
          student.lesson_tutors << tutor
          logger.info "STUDENT #{student.id} is connected with TUTOR #{tutor.id}."
        end
      end
    rescue => e
      logger.error e
    end

    def should_update_index?
      fixed? # 検索インデックスを更新するのは登録が完了したレッスンのみ
    end

    def ensure_not_closed
      if closed?
        errors.add :status, :must_not_be_closed
      end
    end

    def enabling_auto_extension?
      auto_extension_changed? && auto_extension
    end
end

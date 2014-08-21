# coding:utf-8

class Lesson < ActiveRecord::Base
  include Aid::TimeRange
  include JobOwner
  include LessonMoneyMethods
  include LessonRoomMethods
  include LessonExtensionMethods
  include LessonEventHandlerMethods
  include LessonTimeMethods
  include LessonTimeDebugMethods if Rails.env.development?
  include Searchable

  has_event_calendar :start_at_field  => 'start_time', :end_at_field => 'end_time'

  class Status
    BUILD        = 'build'
    NEW          = 'new'
    ACCEPTED     = 'accepted'
    REJECTED     = 'rejected'
    OPEN         = 'open'
    DONE         = 'done'
    RESCHEDULING = 'rescheduling'
    CANCELLED    = 'cancelled'
    NOT_STARTED  = 'not_started'
    ABORTED      = 'aborted'
    IGNORED      = 'ignored'

    class Group
      UNFINISHED        = [ACCEPTED, OPEN, RESCHEDULING]
      FIXED             = [ACCEPTED, OPEN, DONE, RESCHEDULING]
      FIXED_FOR_STUDENT = [NEW, ACCEPTED, OPEN, DONE, RESCHEDULING]
      NOT_ACCEPTED      = [BUILD, NEW]
      GOING_TO_BE_HELD  = [NEW, ACCEPTED]
    end
  end

  class JobQueue
    DOOR_KEEPER    = 'lesson'
    DROPOUT         = 'lesson_dropout'
    CLOSING_PROCESS = 'lesson_closing_process'
    NOTIFICATION    = 'notification'
  end

  searchable auto_index: false do
    integer :tutor_id do
      tutor && tutor.id
    end
    boolean :group_lesson do
      is_group_lesson
    end
    integer :student_count do
      students.count
    end
    boolean :recruiting do
      recruiting?
    end
    boolean :full do
      students.count >= max_student_count
    end
    text :tutor_name do
      tutor && tutor.full_name
    end
    text :tutor_nickname do
      tutor && tutor.nickname
    end
    text :student_names do
      students.map(&:full_name)
    end
    text :student_nicknames do
      students.map(&:nickname)
    end
    string :status
    string :style
    time :start_time
    time :end_time
  end


  class << self
    def duration_per_unit
      LessonSettings.duration_per_unit
    end

    def break_time_length
      5
    end

    def time_to_check_lesson_extension
      15
    end

    def cool_down_period
      5
    end

    def extension_duration
      30
    end

    def min_interval
      15
    end

    def cancellation_time_limit_for_tutor(lesson)
      60.minutes.ago(lesson.start_time)
    end

    def anytime_enterable
      if Rails.env.development?
        false
      else
        false
      end
    end

    def end_time(start_time, units)
      (duration_per_unit * units + break_time_length * (units - 1)).minutes.since(start_time)
    end

    def created_by(user)
      where(creator_id:user.id)
    end

    def new_for_form
      new do |lesson|
        lesson.status = "build"
      end
    end

    def overlap_with(start_at, end_at)
      where("start_time < :end_at AND end_time > :start_at", start_at:start_at, end_at:end_at)
    end

    # lessonと時間がかぶるものに絞る条件
    def conflict_with(lesson, tolerance=0)
      t1 = tolerance.minutes.ago(lesson.start_time)
      t2 = tolerance.minutes.since(lesson.end_time)
      if lesson.new_record?
        where("start_time < :end_at AND end_time > :start_at", start_at:t1, end_at:t2)
      else
        where("lessons.id != :id", id:lesson.id).where("start_time < :end_at AND end_time > :start_at", start_at:t1, end_at:t2)
      end
    end

    def after(time)
      where("start_time > :t", t:time)
    end

    def no_cs_sheet_by(user)
      joins(:lesson_students).includes(:cs_sheets).where(lesson_students:{student_id:user.id}).where(cs_sheets:{author_id:nil})
    end

    def of_settlement_month(year, month)
      where(settlement_year: year, settlement_month: month)
    end

    def charged_on(year, month)
      established
      .of_settlement_month(year, month)
      .includes(:lesson_students => :lesson_charge)
      .where('lesson_charges.id IS NOT NULL')
    end

    def journalize_for_month!(year, month)
      transaction do
        established.of_settlement_month(year, month).each do |lesson|
          lesson.journalize!
        end
      end
    end

    def calculate_cancellation_of_day(day=Date.today)
      Rails.logger.info("Lesson.calculate_cancellation_of_day is called")
    end

    def lesson_server_url
      @lesson_server_url = "http://%{host}:%{port}" % {host:lesson_server_config["host"], port:lesson_server_config["port"]}
    end

    def socket_io_url
      @socket_io_url = "http://%{host}:%{port}/socket.io/socket.io.js" % {host:lesson_server_config["host"], port:lesson_server_config["port"]}
    end

    def cancelled_on(date)
      where(cancelled_at: date.beginning_of_day .. date.end_of_day)
    end

    def lesson_server_config
      @lesson_server_config ||= YAML.load_file(Rails.root.join("config", "lesson_server.yml"))[Rails.env]
    end

    def follow_up_at
      if Rails.env.development?
        5.minutes.from_now
      else
        1.hour.from_now
      end
    end

    def recruiting_group_lessons
      future_for_students.recruiting.going_to_be_held
    end

    def cancellable_statuses
      %w(new accepted rescheduling)
    end

    def statuses_to_become_done
      %w(new accepted open)
    end

    def sweep_ignored_requests
      logger.info 'ENTER: Lesson.sweep_ignored_requests'
      t = LessonSettings.request_acceptance_time_limit.minutes.from_now
      Lesson.under_request.where('start_time < ?', t).each do |ignored_request|
        if ignored_request.reject
          logger.lesson_log 'IGNORED', id: ignored_request.id
        else
          logger.warn "Failed to reject lesson #{ignored_request.id}"
        end
      end
    end

    def extension_fee(base_fee)
      base_fee * extension_duration / duration_per_unit
    end

    def group_lesson_discount(fee)
      fee * RateSettings.group_lesson_discount_rate
    end

    def for_list
      includes(:tutor, :students)
    end

    def reset_door_keeping_jobs
      only_accepted.each do |lesson|
        lesson.reset_door_keeper
      end
    end

    def available_shared_lessons
      shared.future_for_students.order('start_time').not_full
    end

    def fixed_for_student(student)
      where(status: Status::Group::FIXED_FOR_STUDENT).joins(:lesson_students).where(lesson_students: {student_id: student.id, status: LessonStudent::Status::ACTIVE})
    end

    def being_charged_to_student(student)
      where('lessons.established = 1 OR lessons.status IN (?)', Status::Group::FIXED_FOR_STUDENT)
      .joins(:lesson_students)
      .where(lesson_students: {student_id: student.id, status: LessonStudent::Status::ACTIVE})
    end

    def cancel_all
      transaction do
        update_all(status: Status::CANCELLED, cancelled_at: Time.current)
        find_each &:cleanup_on_cancellation
      end
      true
    rescue => e
      logger.error e
      false
    end
  end

  #
  # スコープ
  #
  scope :not_confirmed, where(status:"new")
  scope :future,
        ->{where('lessons.start_time > :t', t:Time.now.beginning_of_day).order(:start_time)}
  scope :future_for_students,
        ->{where('start_time > :t', t: LessonSettings.request_time_limit.minutes.from_now).order('start_time')}
  scope :past,
        ->{where('lessons.end_time < :t', t:Time.now).order('lessons.start_time DESC')}
  scope :unreported,
        ->{includes(:students).includes(:lesson_reports).where(:lesson_reports => {:id => nil}, :status => 'done')}
  scope :of_month,
        ->(month){where(start_time: month.beginning_of_month .. month.end_of_month)}
  scope :current,
        ->{where('start_time < :now AND :now < end_time', now: Time.current)}
  scope :shared, where(type: %w(SharedOptionalLesson SharedBasicLesson))

  scope :under_request, where(status: Status::NEW)
  scope :incomplete,    where(status: Status::BUILD)
  scope :complete,      where('lessons.status != ?', Status::BUILD)
  scope :fixed,         where('lessons.status NOT IN (?)', Status::Group::NOT_ACCEPTED)
  scope :only_done,     where(status: Status::DONE)
  scope :only_fixed,    where(status: Status::Group::FIXED)
  scope :not_fixed,     where(status: Status::NEW)
  scope :unfinished,    where(status: Status::Group::UNFINISHED)
  scope :going_to_be_held, where(status: Status::Group::GOING_TO_BE_HELD)
  scope :not_started, where(status: Status::NOT_STARTED)
  scope :only_accepted, where(status: Status::ACCEPTED)

  scope :established,   where(established:true)
  scope :recruiting,    where(friend_id:nil, is_group_lesson:true).joins(:students).group("lessons.id").having("count(*) < 2")
  scope :not_full,      where(is_group_lesson: true).joins(:lesson_students).group('lessons.id').having('count(*) < 2')
  scope :only_extended, where(extended:true)
  scope :with_cs_point, where('cs_point IS NOT NULL')


  #
  # 関連・属性
  #
  belongs_to :subject
  belongs_to :tutor
  belongs_to :creator, class_name:User.name
  has_many :lesson_students, :dependent => :destroy
  has_many :students, :through => :lesson_students, :uniq => true
  has_many :active_students, :through => :lesson_students, :source => :student,
           :conditions => {lesson_students: {status: LessonStudent::Status::ACTIVE}}
  has_many :cs_sheets
  has_many :lesson_reports
  belongs_to :friend, class_name:Student.name
  has_many :materials, class_name:LessonMaterial.name
  has_one :tutor_lesson_cancellation, :dependent => :destroy
  has_one :lesson_request_rejection

  # 会計科目
  has_many :journal_entries,             class_name:Account::JournalEntry.name
  has_many :group_lesson_discounts,      class_name:Account::GroupLessonDiscount.name
  has_many :lesson_extension_fees,       class_name:Account::LessonExtensionFee.name
  has_many :lesson_extension_tutor_fees, class_name:Account::LessonExtensionTutorFee.name
  has_many :beginner_tutor_discounts,    class_name:Account::BeginnerTutorDiscount.name

  attr_accessible :end_time, :start_time, :type, :units, :is_group_lesson
  attr_accessible :status, :started_at, :delayed, :cancelled_by, :extension_enabled,
                  :show_on_calendar, :schedule_fixed, :not_started,
                  :established,
                  as: :admin

  #
  # 検証
  #
  validates_presence_of :status
  validates_inclusion_of :status, :in => %w(build new accepted open done reported rejected ignored cancelled aborted not_started rescheduling)
  validates_inclusion_of :accounting_status, :in => %w(unprocessed incomplete processed)
  validates_presence_of :tutor, :start_time, :end_time, :unless => :build?, :unless => :cancel
  validates_length_of :students, :minimum => 1,         :unless => :build?
  validate :check_conflicts
  validate :start_time_change_limit, :on => :update
  validate :was_cancellable_status, :if => 'status_changed? && cancelled?'
  validate :premise_to_accept, :if => 'status_changed? && accepted?'
  validate :can_become_done, :if => :become_done?
  validate :ensure_schedule_can_change, :if => :schedule_changed?
  validate :ensure_able_to_establish, :if => :establishing?
  validates_presence_of :tutor_base_hourly_wage, if: :tutor_id, :unless => :schedule_changed?

  #
  # フック
  #
  before_validation :resolve_end_time
  after_validation  :set_original_schedule, on: :create

  before_save :update_settlement_month
  before_save :update_status, :update_status_flags

  # after_update :on_status_changed,   :if => :status_changed?
  after_update :on_schedule_changed, :if => :schedule_changed?
  after_update LessonRoomKeeper
  after_update LessonStatusMonitor
  after_update LessonChargingMonitor
  after_update LessonRegistrationEventHandler.new

  #################################################################
  # 状態
  #################################################################

  def optional?
    false
  end

  def basic?
    false
  end

  def schedule_changeable?
    true
  end

  # 無料レッスン
  def free?
    self.type == FreeOptionalLesson.name
  end

  # 作成中（ウィザード）のときtrue
  def build?
    status == Status::BUILD
  end

  # レッスン申込み中
  def new?
    status == Status::NEW
  end

  def under_request?
    status == Status::NEW
  end

  def building_or_requesting?
    build? || under_request?
  end

  # レッスンが開催される（開催された）場合にtrueを返す
  def active?
    !inactive?
  end

  # レッスンが開催されないことが確定していればtrueを返す
  def inactive?
    build? || rejected? || ignored? || cancelled?
  end

  def show_entrance?
    accepted? || open? || done?
  end

  def fixed?
    !(build? || rejected? || ignored? || new?)
  end

  def fixed_for_student?
    Status::Group::FIXED_FOR_STUDENT.include? status
  end

  # 申し込み中または開催予定の場合にtrueを返す
  def going_to_be_held?
    new? || accepted?
  end

  # レッスン画面を開いてもよい状態であればtrueを返す
  def can_open?
    accepted? || open?
  end

  def cancelled?
    status == Status::CANCELLED
  end

  def ignored?
    status == Status::IGNORED
  end

  def done?
    status == Status::DONE
  end

  def aborted?
    status == Status::ABORTED
  end

  def finished?
    done? || aborted?
  end

  def accepted?
    status == Status::ACCEPTED
  end

  def acceptable?
    Time.current < request_acceptance_time_limit
  end

  def rejected?
    status == Status::REJECTED
  end

  # すべての受講者がCSシートを書いていればtrueを返す
  # 「実際に授業に参加した」受講者の分だけをカウントしていることに注意。
  # 受講者が一人も参加していない場合もtrueになる。
  def cs_sheets_collected?
    cs_sheets_collected || attended_students.all?{|student| cs_sheet_written_by(student).present?}
  end

  # 受け取っていないCSシートの数
  # (授業に参加した生徒数) - (提出されたCSシート枚数)
  def unreceived_cs_sheets_count
    attended_students.count - cs_sheets.count
  end

  def open?
    status == Status::OPEN
  end

  def rescheduling?
    status == Status::RESCHEDULING
  end

  # 満席でない && 開催待ち状態 && 開室時間前であればtrueを返す
  def recruiting?
    !full? && going_to_be_held? && (Time.current < request_time_limit)
  end

  def add_student(student)
    if member_student?(student)
      errors.add :students, :alreay_member
    elsif full?
      errors.add :students, :full
    elsif !recruiting?
      errors.add :students, :cannot_add
    end
    if errors.empty?
      self.students << student
      true
    else
      false
    end
  end

  # 受講者を追加する。
  # 満員の場合は先頭の人を追い出す。
  def push_student(student)
    return false if member_student? student
    transaction do
      if full?
        self.students.destroy(students.first)
      end
      self.students << student
    end
  end

  def can_add_student?(student)
    !member_student?(student) && recruiting?
  end

  def member_student?(student)
    student_ids.include? student.id
  end

  # 生徒をこれ以上追加できなければtrue
  def full?
    students.length >= max_student_count
  end

  # 現在授業時間中ならtrue
  # 実際にチューターが授業を行なっているかどうかは関係なく時刻だけを見る。
  def current?
    now = Time.now
    start_time <= now && now <= end_time
  end

  # 複数人のレッスンであればtrueを返す。
  # キャンセルした受講者はカウントしない。
  def group_lesson?
    active_students.count > 1
  end

  # 同時レッスン割引の対象となる場合trueを返す
  def group_lesson_discount_applicable?
    lesson_students.remaining.count > 1
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

  def has_option_to_extend?
    true
  end

  def entered?(user)
    if user.is_a?(Tutor)
      tutor == user && tutor_entered_at.present?
    elsif user.is_a?(Student)
      students.include?(user) && lesson_students.find_by_student_id(user.id).entered?
    end
  end

  def started?
    started_at.present?
  end

  def ended?
    ended_at && ended_at < Time.now
  end

  def time_changeable?
    false
  end

  def past?
    end_time && end_time.past?
  end

  # このレッスンの時間帯がチューターの指導可能な時間帯の範囲内であればtrueを返す。
  # チューターが指導可能な時間帯を一つも登録していない場合もtrueを返す。
  # チューターおよび開始・終了時刻がセットされていない場合はfalseを返す。
  def match_with_tutor_weekday_schedule?
    if ready_to_check_tutor_schedule?
      schedules = tutor.weekday_schedules
      if schedules.empty?
        true # 時間が指定されていなければいつでも指導可能とみなす。
      else
        schedules.any?{|schedule| schedule.include?(start_time, end_time)}
      end
    else
      false
    end
  end

  # チューターが指導できないと設定した日が開催予定であればtrueを返す。
  # チューターと時間が設定されていなければfalseを返す。
  def tutor_unavailable_day?
    if ready_to_check_tutor_schedule?
      tutor.unavailable_days.any?{|d| d.date == date}
    else
      false
    end
  end

  # 日程を変更できればtrueを返す
  def can_change_schedule?
    !optional? && accepted? && before_entry_start_time? && !(group_lesson? || is_group_lesson)
  end

  def future?
    start_time.future?
  end

  #################################################################
  # レッスンの延長
  #################################################################


  #################################################################
  # 操作
  #################################################################

  #レッスン予約申込を確定する。
  def fix!
    if build?
      self.status = 'new'
      save!
      lesson_students.each{|s| s.on_lesson_fixed}
    end
  end

  def fix
    if build?
      self.status = Status::NEW
      save
    else
      false
    end
  end

  # レッスンをキャンセルする
  def cancel(canceller=nil)
    if cancelled?
      true
    else
      self.status = Status::CANCELLED
      self.cancelled_at = Time.current
      if canceller.present?
        self.cancelled_by = canceller.id
      end
      save
    end
  end

  def cancel_by_tutor(reason = I18n.t('common.no_reason'))
    tutor_lesson_cancellation || create_tutor_lesson_cancellation(reason: reason)
  end

  def cancelled_by_tutor?
    tutor_lesson_cancellation.present?
  end

  # 現在このレッスンをキャンセルできる期間中であればtrueを返す。
  # 結果は引数に与えたユーザーのタイプによって異なる。
  def cancellation_period_for?(user)
    false # 実装はサブクラスでする。
  end

  def student_status(student)
    lesson_students.find_by_student_id(student.id)
  end

  def student(student)
    lesson_students.of_student(student)
  end

  def have_active_students?
    lesson_students.remaining.present?
  end

  # レッスン自体をキャンセルする
  # キャンセルを実行した人を記録する
  def cancel_by(user)
    if user.can_cancel?(self)
      transaction do
        if cancel(user)
          user.on_lesson_cancelled(self)
          true
        else
          false
        end
      end
    else
      logger.error "Failed to cancel lesson ##{id}"
      false
    end
  end

  # 授業が開始されたことを記録する
  # 開始時刻を１０分超えていると開始できない。
  def start!(at=Time.zone.now)
    if started_at.blank?
      update_attributes!({status: Status::OPEN, started_at: at, delayed: at > start_time}, as: :admin)
      on_started
    end
  end

  # 授業を終了する際に呼ぶ。
  # ひとつのレッスンに付き最大１回しか呼べない。
  # 2回以上呼ぶと例外を投げる
  def done!(at=Time.now)
    if ended_at.present?
      raise "This lessen has already done."
    end
    self.status = 'done'
    self.ended_at = at
    save!
  end

  def follow_up
    if finished?
      attended_students.each do |student|
        # CSシートを書いていなかったら保護者に連絡する
        if cs_sheets.written_by(student).empty?
          Mailer.send_mail(:cs_report_not_written, self, student)
        end
      end
    end
  end

  def accept!
    self.status = 'accepted'
    save!
    self
  end

  def accept
    self.status = 'accepted'
    save
    self
  end

  def reschedule!
    if accepted?
      update_attribute(:status, 'rescheduling')
    end
  end

  def reject!
    if new?
      update_attribute(:status, 'rejected')
    end
  end

  def reject
    return false unless new?
    update_attribute(:status, 'rejected').tap do |success|
      if success
        logger.lesson_log 'LESSON_REQUEST_REJECTED', log_attributes
      else
        logger.lesson_log 'LESSON_REQUEST_FAILED_TO_REJECT', log_attributes
      end
    end
  end

  def ignore!
    if new?
      update_attributes!({status: 'ignored'}, as: :admin)
    end
  end

  # 授業を開始する
  # 授業が「受付済み」状態でなければ何もしない。
  # 例外を投げたほうがよい？
  def open!
    if status == 'accepted'
      start!
    end
  end

  def open_and_notify
    open!
    notify_status_change_to_attendees
  end

  # 授業を終了したことにする。
  # 授業が開催中でなければ何もしない。
  # 例外を投げたほうがよい？
  def close!
    if status == 'open'
      done!
    end
  end

  def close
    self.status = 'done'
    save
    self
  end

  def abort
    update_attribute(:status, 'aborted').tap do |success|
      clear_door_keeper if success
    end
  end

  # 授業を成立したことにする。
  # これにより授業料等の支払が確定する。
  def establish
    update_attributes({established: true}, as: :admin)
  end

  def establishing?
    established_changed? && established?
  end

  # 古いバックグラウンドジョブが実行されてもエラーとならないようしばらく残しておく
  def close_door!
  end

  # 授業が開始時刻を過ぎ、遅刻許容時間を過ぎても開始されなかったときに呼び出す
  def tutor_not_show_up
    unless started?
      unless not_started?
        update_attributes!({status: Status::NOT_STARTED, not_started: true}, as: :admin)
      end
      logger.lesson_log('TUTOR_DID_NOT_SHOW_UP', log_attributes)
      tutor.on_lesson_skipped(self)
    end
  end

  # チューターを変更する
  # TODO:変更内容によってはチューターにペナルティが発生するらしいが内容が未定
  def change_tutor!(new_tutor)
    if tutor != new_tutor
      transaction do
        old_tutor = tutor
        self.tutor = new_tutor
        save!
        old_tutor.on_taken_off_lesson(self)
      end
    end
  end

  def change_time!(time)
    if time_changeable?
      self.start_time = time
      save!
    else
      raise 'Can not change the lesson time.'
    end
  end

  ####################################################################
  # 同時レッスンに関するもの
  ####################################################################

  # このレッスンを同時レッスン可能にする
  # 参加できる生徒の制限はクリアされる。
  def group_lesson!(flag=true)
    self.is_group_lesson = flag
    self.friend = nil
    self.save!
  end

  def max_student_count
    is_group_lesson ? 2 : 1
  end

  ####################################################################
  # 関連オブジェクトへのアクセス
  ####################################################################

  def cs_sheet_written_by(user)
    cs_sheets.find_by_author_id(user.id)
  end

  def report_of(student)
    lesson_reports.find_by_student_id(student.id)
  end

  # 実際にレッスンに参加した生徒
  def attended_students
    students.includes(:lesson_students).where('lesson_students.attended_at IS NOT NULL')
  end

  def deals
    Deal::Base.where(lesson_id:id)
  end

  ###########################################################
  # ユーティリティ的なプロパティ
  ###########################################################

  # カレンダーUI用の属性
  # TODO: name以外のものが使えるか調査
  def name(time_format = :only_time)
    "#{tutor.nickname} #{I18n.l(start_time, :format => time_format)}"
  end

  def subject_name
    subject && subject.name
  end

  def tutor_nickname
    tutor && tutor.nickname
  end

  def tutor_full_name
    tutor && tutor.full_name
  end

  def duration
    (end_time - start_time) / 60
  end

  def settlement_date
    DateUtils.next_month_of(start_time)
  end

  def date
    start_time.to_date
  end

  def units_select_options
    min = students.any? ? students.first.min_lesson_units : 1
    (min .. LessonSettings.instance.max_units).to_a
  end

  def weekday_time_range
    WeekdayTimeRange.new(start_time:start_time, end_time:end_time)
  end

  def active_student_emails
    students.where(lesson_students: {status: 'active'})
    lesson_students.remaining
  end

  def student_emails
    students.flat_map(&:emails)
  end

  def student_materials(student)
    materials.owned_by(student)
  end

  def organizations
    students.map(&:organization).uniq
  end

  def organization_emails
    organizations.map(&:emails).flatten.uniq
  end

  ###############################################################

  # single, friends, shared
  def style
    if group_lesson?
      if friend.present?
        :friends
      else
        :shared
      end
    else
      :single
    end
  end

  def trial?
    style == :trial
  end

  def notifications
    jobs.where(queue: 'notification')
  end

  def log_attributes
    {id:id, type:type, tutor_id:tutor_id,
     start_time:start_time, end_time:end_time,
     status:status,
     started_at:started_at, ended_at:ended_at,
     door_closed:door_closed, extended:extended,
     cancelled_by:cancelled_by, cancelled_at:cancelled_at,
     established:established, journalized_at:journalized_at}
  end

  def time_range
    if start_time && end_time
      start_time .. end_time
    end
  end

  def members
    User.where(id: member_ids)
  end

  def member?(user)
    member_ids.include? user.id
  end

  def member_ids
    @member_ids ||= [tutor_id, *student_ids].compact.uniq
  end

  def cleanup_on_cancellation
    refund
    clear_scheduled_jobs
  end

  private

    def calculate_cs_point
      if cs_sheets.empty?
        0
      else
        cs_sheets.inject(0){|sum, cs_sheet| sum + cs_sheet.cs_point}.to_f / cs_sheets.count
      end
    end

    # 時間の変更は翌月の２０日まで
    def start_time_change_limit
      if original_start_time && start_time_changed?
        limit = original_start_time.next_month.change(day:SystemSettings.cutoff_date).end_of_day
        if start_time > limit
          errors.add(:start_time, :over_limit)
        end
        if start_time < 15.minutes.from_now
          errors.add(:start_time, :too_near_or_past)
        end
      end
    end

    # 時間帯が既存のレッスンと衝突していないかチェックする
    def check_conflicts
      # ベーシックレッスンとの衝突をチェック
      check_conflicts_with_basic_lesson_infos
      check_conflicts_with_lessons
    end

    def check_conflicts_with_basic_lesson_infos
      # BasicLessonとOptionalLessonの場合でチェック内容が異なるので
      # それぞれのクラスでオーバーライドする
    end

    def check_conflicts_with_lessons
      if start_time && end_time
        if tutor
          tutor.lessons.only_fixed.conflict_with(self, Lesson.min_interval).each do |lesson|
            errors.add(:time_range,
                       :conflict_with_lesson_for_tutor,
                       time_range: lesson.time_range_string)
          end
        end
        students.each do |student|
          student.lessons.fixed_for_student(student).conflict_with(self, Lesson.min_interval).each do |lesson|
            errors.add(:time_range,
                       :conflict_with_lesson_for_student,
                       student: student.nickname,
                       time_range: lesson.time_range_string)
          end
        end
      end
    end

    # このチェックは更新時に１００％当てはまるので作成時にしか適用しない
    def tutor_available
      if tutor && start_time && end_time && !tutor.available?(start_time .. end_time)
        errors.add(:start_time, :tutor_unavailable)
      end
    end

    def friend_belongs_to_same_bs
      if friend && friend.organization != students.first.organization
        errors.add(:friend, :friend_belongs_to_different_organization)
      end
    end

    def time_range_given_or_on_create?
      if build?
        start_time.present? && end_time.present?
      else
        new_record?
      end
    end

    # 状態が変化した後に実行する処理をまとめて書く
    def on_status_changed
      logger.lesson_log 'STATUS_CHANGED',
                        id: id, start_time: start_time, end_time: end_time,
                        from: status_was, to: status
      case status
      when Status::RESCHEDULING
        # チューターと生徒にメールを出す
        Mailer.send_mail(:lesson_schedule_change_requested, self)
      when Status::CANCELLED
        on_cancelled
      when Status::DONE
        on_done
      when Status::ACCEPTED
        on_accepted
      when Status::NOT_STARTED
        on_skipped
      else
        # do nothing
      end
    end

    # 開始時刻が変更された時に呼ばれる
    def on_schedule_changed
      reset_scheduled_jobs
      logger.lesson_log('SCHEDULED_CHANGED', attributes)
    end

    def reset_scheduled_jobs
      reset_notifications
      reset_door_keeper
    end

    # 開始時刻事前通知をセットする
    def reset_notifications
      clear_notifications
      times =[24.hours.ago(start_time), 2.hours.ago(start_time), 15.minutes.ago(start_time)]
      times.each do |t|
        send_at_from_queue(JobQueue::NOTIFICATION, t, :notify_coming) if t > Time.now
      end
    end

    def clear_scheduled_jobs
      clear_notifications
      clear_door_keeper
    end

    def clear_notifications
      clear_queue(JobQueue::NOTIFICATION)
    end

    def clear_door_keeper
      clear_queue(JobQueue::DOOR_KEEPER)
    end

    def notify_coming
      Mailer.send_mail(:lesson_coming_notification, self)
    end

    # レッスン入室時間に関するタスクを登録する
    def reset_door_keeper
      clear_door_keeper
      set_task_on_tutor_entry_start_time
      set_task_on_tutor_entry_end_time
      set_task_on_student_entry_start_time
      set_task_on_student_entry_end_time
    end

    def set_task_on_tutor_entry_start_time
      if Time.now < tutor_entry_start_time
        send_at_from_queue(JobQueue::DOOR_KEEPER, tutor_entry_start_time, :on_tutor_entry_start_time)
      end
    end

    def set_task_on_tutor_entry_end_time
      if Time.now < tutor_entry_end_time
        send_at_from_queue(JobQueue::DOOR_KEEPER, tutor_entry_end_time, :on_tutor_entry_end_time)
      end
    end

    def set_task_on_student_entry_start_time
      # 何もしない
    end

    def set_task_on_student_entry_end_time
      # 何もしない
    end

    # レッスンの最終退室時刻に実行するタスクを登録する
    def reset_closing_process
      clear_queue(JobQueue::CLOSING_PROCESS)
      send_at_from_queue(JobQueue::CLOSING_PROCESS, time_room_close, :close!)
    rescue => e
      logger.error e
    end

    # レッスンの途中キャンセル締切時刻に実行するタスクを登録する
    def reset_dropout_time_limit
      clear_queue(JobQueue::DROPOUT)
      if started?
        if Time.now < dropout_closing_time
          send_at_from_queue(JobQueue::DROPOUT, dropout_closing_time, :on_dropout_closing_time)
        end
      else
        logger.warn "Lesson #{id}'s reset_dropout_time_limit is called when the lesson is not started."
      end
    rescue => e
      logger.error e
    end

    # 状態に関連するフラグを更新する
    # rescheduling状態でschedule_fixedとしてるのは、現在の日程を押さえておくため
    def update_status_flags
      if new? || rescheduling?
        self.schedule_fixed = true
        self.show_on_calendar = false
      elsif accepted? || open? || done? || aborted?
        self.schedule_fixed = true
        self.show_on_calendar = true
      elsif cancelled? || build? || rejected? || ignored?
        self.schedule_fixed = false
        self.show_on_calendar = false
      end
      true # falseを返すとコールバックで使えない。
    end

    def update_status
      if rescheduling?
        if start_time_changed?
          self.status = Status::ACCEPTED
        end
      end
    end

    def notify_to_attendees(message, params={})
      uri = URI.parse(lesson_server_message_url(message))
      logger.lesson_log('POST_TO_LESSON_SERVER', uri: uri.to_s)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        logger.info 'HTTPS connection'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-type'] = 'application/json'
      request['Accept']       = 'application/json'
      unless params.empty?
        request.body = params.to_json
      end
      http.start do |h|
        response = h.request(request)
        logger.lesson_log('POSTED_TO_LESSON_SERVER', code: response.code)
      end
      logger.lesson_log('NOTIFIED', type:'changed')
    end

    def lesson_server_message_url(message)
      config = Lesson.lesson_server_config
      "#{config['scheme']}://#{config['host']}:#{config['port']}/lessons/#{id}/#{message}"
    end

    def notify_status_change_to_attendees
      notify_to_attendees 'changed'
    end

    def was_cancellable_status
      unless Lesson.cancellable_statuses.include? status_was
        errors.add :status, :not_cancellable
      end
    end

    def premise_to_accept
      unless status_was == 'new'
        errors.add :status, :not_to_be_accepted
      end
    end

    def can_become_done
      errors.add :status, :cannot_become_done unless Lesson.statuses_to_become_done.include? status_was
    end

    def become_done?
      status_changed? && done?
    end

    def schedule_changed?
      !start_time_was.nil? && accepted? && start_time_changed?
    end

    def ensure_schedule_can_change
      errors.add :start_time, :cannot_change_because_group_lesson unless can_change_schedule?
    end

    def ensure_able_to_establish
      unless Status::Group::FIXED_FOR_STUDENT.include? status_was
        errors.add :status, :not_in_state_to_become_established
      end
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

    # このレッスンに関する仕訳データ、参加者の月次集計を更新する
    def update_accountings
      logger.info "Lesson#update_accountings START #{id}"
      transaction do
        clear_journal_entries if journalized?
        journalize!
        members.each do |m|
          m.update_monthly_statement_for(settlement_year, settlement_month)
        end
        organizations.each do |org|
          org.create_monthly_statement_update_request(settlement_year, settlement_month)
        end
      end
      logger.info "Lesson#update_accountings FINISH #{id}"
    end

    def ready_to_check_tutor_schedule?
      tutor && start_time && end_time
    end

    def should_update_index?
      !build? # 検索インデックスを更新するのは登録が完了したレッスンのみ
    end

    def resolve_end_time
      if start_time && units
        self.end_time = Lesson.end_time(start_time, units)
      end
    end

    def set_original_schedule
      self.original_start_time = start_time
      self.original_end_time = end_time
    end
end

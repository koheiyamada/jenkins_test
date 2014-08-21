# coding:utf-8

class Student < User
  include BasicLessonMember
  include StudentMoneyMethods
  include BankAccountOwner
  include MembershipManagement
  include Payer
  include Searchable

  class << self
    def user_name_prefix
      'u'
    end

    def yucho_payers
      direct_payers = joins(:payment_method).where(payment_methods: {type: YuchoPayment.name})
      parents = Parent.joins(:payment_method).where(payment_methods: {type: YuchoPayment.name})
      indirect_payers = Student.where(parent_id: parents.map(&:id))
      direct_payers.to_a + indirect_payers.to_a
    end

    # 指定した月に入会した受講者の一覧を返す。
    def enrolled_in(year, month)
      month = Date.new(year, month)
      from = month.prev_month.to_time.change(day: SystemSettings.cutoff_date + 1).beginning_of_day
      to   = month.to_time.change(day: SystemSettings.cutoff_date).end_of_day
      where(created_at: from .. to)
    end

    def for_list
      includes(:student_info, :organization, :student_info => :grade)
    end

    # 入会金を支払う受講者を返す
    # (入会中) && (現在入会後31日目以降である) && (入会金を支払っていない)
    ### && (一般会員)
    def to_pay_entry_fee
      only_active.only_premium.includes(:entry_fee).where('users.enrolled_at < :date AND account_journal_entries.id IS NULL', date: 30.days.ago.beginning_of_day)
    end
  end

  # 検索インデックス
  searchable auto_index: false do
    integer :student_id, using: :id
    integer :organization_id

    # アカウントの状態
    boolean :active, using: :active?
    boolean :locked, using: :locked?
    boolean :left,   using: :left?
    boolean :trial,  using: :trial?
    time    :current_sign_in_at
    date    :registered_day

    # 無料体験レッスン受講回数
    integer :free_lesson_taken

    # 無料体験会員
    string :customer_type

    # 名前
    text :full_name
    text :full_name_kana
    text :nickname

    # 属性
    date :birthday
    text :school
    integer :grade_id
    text :note

    # 連絡先
    text :emails
    text :phone_number
    text :skype_id
    text :postal_code do
      address && address.postal_code
    end
    text :address do
      address && address.serialize
    end

    # 保護者情報
    text :parent_user_name do
      parent && parent.user_name
    end
    text :parent_full_name do
      parent && parent.full_name
    end

    # BS
    text :area_code
    text :coach_user_name do
      coach && coach.user_name
    end
    text :coach_full_name do
      coach && coach.full_name
    end

    text :organization_name do
      organization && organization.name
    end

    # 紹介者
    text :reference_user_name
  end

  scope :with_textbook_usage, includes(:student_info).where(student_infos:{use_textbooks:true})
  scope :only_independent, where(parent_id:nil)
  scope :exclude_trial, where("type != 'TrialStudent'")

  has_one :settings, class_name:StudentSettings.name, :dependent => :destroy

  has_many :lesson_students, :dependent => :destroy
  has_many :lessons, :through => :lesson_students, :uniq => true
  has_many :lesson_invitations, :dependent => :delete_all
  has_many :invited_lessons, :through => :lesson_invitations, :source => :lesson
  # 参加した/参加予定のレッスン
  has_many :active_lesson_students, class_name: LessonStudent.name, :foreign_key => :student_id,
           :conditions => {status: LessonStudent::Status::ACTIVE}
  has_many :active_lessons, :through => :active_lesson_students, :source => :lesson,
           :conditions => {status: Lesson::Status::Group::FIXED_FOR_STUDENT}

  belongs_to :parent
  has_many :lesson_reports, :dependent => :destroy
  has_many :student_favorite_tutors, :dependent => :delete_all
  has_many :favorite_tutors, :through => :student_favorite_tutors, :source => :tutor
  has_many :student_lesson_tutors, :dependent => :delete_all
  has_many :lesson_tutors, :through => :student_lesson_tutors, :source => :tutor, :uniq => true

  has_one :student_info, :autosave => true, :validate => true, :dependent => :delete
  has_many :basic_lesson_students, :dependent => :destroy
  has_many :basic_lesson_infos, :through => :basic_lesson_students
  has_many :student_exams
  has_many :exams, :through => :student_exams, :dependent => :destroy
  has_one :registration_form, class_name:StudentRegistrationForm.name, :foreign_key => :user_id, :dependent => :destroy
  # 教育コーチ
  has_one :student_coach, :dependent => :destroy
  has_one :coach, class_name: User.name, :through => :student_coach, :source => :coach

  # 料金科目
  # 削除はUser#journal_entriesの削除で行われる
  has_one :entry_fee, class_name:Account::EntryFee.name, :as => :owner
  has_many :id_management_fees, class_name:Account::StudentIdManagementFee.name, :as => :owner
  has_many :textbook_usage_fees, class_name:Account::TextbookUsageFee.name, :as => :owner
  has_many :student_referral_fees, class_name:Account::StudentReferralFee.name, :as => :owner
  has_many :hq_user_reference_discounts, class_name: Account::HqUserReferenceDiscount.name, :as => :owner

  delegate :school, :referenced_by_hq_user, :referenced_by_hq_user?,
           :grade_id, :grade, :grade=,
           :note,
           to: :student_info

  attr_accessible :parent, :free_lesson_taken, :free_lesson_reservation

  validates_presence_of :email,
                        :address,
                        :phone_number,
                        :first_name, :last_name,
                        :first_name_kana, :last_name_kana,
                        :birthday,
                        :sex,
                        :nickname,
                        :organization_id
  validates_format_of :email, :with => Student.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?
  validates_presence_of :payment_method, :on => :create,  :if => :independent?
  validates_uniqueness_of :nickname, allow_blank: true, message: :taken

  validate :ensure_student_can_leave, :if => :leaving?

  before_validation do
    if student_info.blank?
      self.student_info = StudentInfo.new
    end
    if organization.blank?
      self.organization = resolve_organization
    end
  end

  before_create do
    if parent.present?
      self.status = 'active'
    end
    if student_info.blank?
      self.student_info = StudentInfo.new
    end
  end

  before_save :update_reference, if: :reference_user_name

  after_create :init_settings
  after_create :reset_coach
  after_create :create_document_camera # has_oneにより生成されるメソッド

  after_update do
    if reference.present? && reference_id_changed?
      journal_student_referral_fee
    end
  end

  before_create :assign_organization_from_address
  after_save :on_organization_changed, if: :organization_id_changed?

  after_save :update_student_info

  before_destroy :destroy_all_basic_lesson_infos

  def root_path
    st_root_path
  end

  def trial?
    false
  end

  def min_lesson_units
    1
  end

  def tutors
    Tutor.scoped
  end

  def basic_lesson_tutors
    @basic_lesson_tutors ||= basic_lesson_infos.only_current.map(&:tutor).compact.uniq
  end

  def students
    Student.where(organization_id:organization_id)
  end

  def subjects
    grade.subjects
  end

  def cs_sheets
    CsSheet.written_by(self)
  end

  def bss
    if organization
      organization.is_a?(Bs) ? [organization] : []
    else
      []
    end
  end

  def change_bs(bs)
    self.organization = bs
    save
    self
  end

  def area_code
    if address.present?
      address.area_code
    end
  end

  def search_lesson_reports(key, options={})
    # 自分のレポートに限定する
    super(key, options.merge(student_id:id))
  end

  def teach_by_using_textbooks
    student_info && student_info.teach_by_using_textbooks
  end

  def use_textbooks?
    student_info && student_info.use_textbooks
  end

  def use_textbooks=(flag)
    if student_info
      student_info.update_attribute(:use_textbooks, flag.present?)
    end
  end

  def academic_results
    student_info && student_info.academic_results
  end

  # 無料会員になった日が記録されている場合そちらを、記録されていない場合入会日を表示する
  def registered_day
    date_of_becoming_free_user && date_of_becoming_free_user.to_date || enrolled_at && enrolled_at.to_date
  end

  ############################################################
  # レッスン関連
  ############################################################

  # 現在有効なベーシックレッスンと申請中のベーシックレッスンの日程一覧を返す
  def basic_lesson_weekly_schedules
    ids = basic_lesson_infos.fixed_for_student.pluck(:id)
    BasicLessonWeekdaySchedule.where(basic_lesson_info_id: ids)
  end

  def join_lesson(lesson)
    lesson.add_student(self)
  end

  def of_lesson(lesson)
    lesson_students.find_by_lesson_id(lesson.id)
  end

  def fixed_basic_lesson_infos
    basic_lesson_infos.fixed
  end

  # 受講する、あるいは受講したオプションレッスン
  def optional_lessons
    lessons.where(type:"OptionalLesson")
  end

  # 現在この受講者が指定したレッスンに参加できる場合にtrueを返す
  def can_enter_lesson?(lesson)
    if lesson.period_to_enter_for?(self)
      # 入室可能な時間帯の場合、すでに受講者がキャンセル済でなければ入室できる
      lesson.student(self).active?
    else
      # 入室可能な時刻の範囲外の場合、すでに一度入室済みであれば再入室可能とする。
      lesson.entered?(self) && !lesson.finished?
    end
  end

  def should_write_cs_sheet?(lesson)
    (lesson.finished? || (lesson.started? && lesson.student_attended?(self) && Time.now > lesson.end_time)) && lesson.cs_sheet_written_by(self).blank?
  end

  def in_lesson?
    lessons.current.any?
  end

  def in_meeting?
    meetings.current.any?
  end

  def in_exam?
    # TODO: 模試は未実装なので常にfalseを返す
    false
  end

  def busy?
    in_lesson? || in_meeting? || in_exam?
  end

  # アカウントを有効にする
  # イベント：入会金が発生する
  def activate!
  end

  def exams_of_this_year
    exams.of_this_year
  end

  def available_exams
    Exam.of_this_year.for_grade(grade)
  end

  def grade
    student_info.grade
  end


  #######################################################################
  ### 模試関連メソッド
  #######################################################################

  def take_exams(exam_id_list)
    self.exams = Exam.find(exam_id_list)
    self.save!
  end

  def take?(exam)
    # 複数回呼ばれてもDBへの問い合わせが１度で済むようにstudent_examsを全部ロードする形にしている。
    student_exams.any?{|e| e.exam_id == exam.id}
  end

  def take_exam!(exam)
    self.exams << exam
    save!
  end

  def exam_record_of(exam)
    student_exams.find_by_exam_id(exam.id)
  end

  def can_start_exam?(exam)
    exam.available? && !exam_record_of(exam).done?
  end

  # このレッスンへの参加を取りやめる
  def cancel_lesson(lesson, options = {})
    options = {reason: I18n.t('common.no_reason')}.merge(options)
    lesson.student(self).cancel options
  end

  # 参加中のレッスンから引き上げる
  def drop_out_from_lesson(lesson)
    of_lesson(lesson).drop_out
  end

  ################################################################
  # 権限
  ################################################################

  # このユーザがレッスンをキャンセル可能ならtrueを返す
  def can_cancel?(lesson)
    lesson.cancellable_by_student?(self)
  end

  def can_cancel_more?(lesson)
    if lesson.optional?
      can_cancel_optional_lesson_for_month?(lesson.start_time)
    elsif lesson.basic?
      can_cancel_basic_lesson_for_month?(lesson.start_time)
    else
      false
    end
  end

  def independent?
    parent_id.nil?
  end

  ################################################################
  # 設定値
  ################################################################

  def optional_lesson_cancellation_limit_per_month
    9999
  end

  def basic_lesson_cancellation_limit_per_month
    9999
  end

  #################################################################
  # 会計関連
  #################################################################

  def organization_emails
    organization.present? ? organization.emails : []
  end

  # Addressが呼び出す
  def on_address_changed(address)
    bs = BsCustomer.new(self).resolve_bs!
    if bs.headquarter?
      Mailer.send_mail(:student_no_bs_found, self)
    end
    logger.account_log('ADDRESS_CHANGED', log_attributes)
  end

  def on_monthly_charge_updated(year, month)
    # 使用状況を更新してから、制限に近づいていないかチェックして、
    # 制限が迫っていれば警告メールを出す。
    usage = monthly_stats_for(year, month).update_usage
    if usage.valid?
      if charge_limit_approaching?(year, month)
        Mailer.send_mail(:charge_limit_approaching, self)
      end
    end
  end

  def charge_limit_approaching?(year, month)
    usage = monthly_stats_for(year, month)
    usage.lesson_charge < settings.max_charge && usage.lesson_charge + 10000 > settings.max_charge
  end

  def ready_to_pay?
    if independent?
      active?
    else
      #parent.has_credit_card?
      true # 保護者が支払準備を終えていなければ生徒を登録できないので、常にtrueとして差し支えない。
    end
  end

  # 退会時のチェック
  def validate_membership_cancellation(membership_cancellation)
    if in_lesson?
      membership_cancellation.errors.add :user, I18n.t('student.cannot_cancel_membership_because_in_lesson')
    end
    if in_meeting?
      membership_cancellation.errors.add :user, I18n.t('student.cannot_leave_because_in_meeting')
    end
    if in_exam?
      membership_cancellation.errors.add :user, I18n.t('student.cannot_leave_because_in_exam')
    end
  end

  #
  # 教育コーチ
  #

  # callback
  def reset_coach
    BsCustomer.new(self).reset_coach
    self
  end

  #idを渡された場合は対象のユーザーの値を変更、なにも渡されなければ自分自身の値変更
  def count_up_free_lesson_taken id=nil
    if id.present?
      target = User.where(id: id)[0]
      if target.free?
        target.free_lesson_taken += 1
        target.save!
      end
    else
      self.free_lesson_taken += 1
      self.save!
    end
  end

  def count_down_free_lesson_taken id=nil
    if id.present?
      target = User.where(id: id)[0]
      if target.free?
        target.free_lesson_taken -= 1
        target.save!
      end
    else
      self.free_lesson_taken -= 1
      self.save!
    end
  end

  def count_up_free_lesson_reservation id=nil
    if id.present?
      target = User.where(id: id)[0]
      if target.free?
        target.free_lesson_reservation += 1
        target.save!
      end
    else
      self.free_lesson_reservation += 1
      self.save!
    end
  end

  def count_down_free_lesson_reservation id=nil
    if id.present?
      target = User.where(id: id)[0]
      if target.free?
        if target.free_lesson_reservation <= 0
          target.free_lesson_reservation = 0
        else
          target.free_lesson_reservation -= 1
        end
        target.save!
      end
    else
      if self.free_lesson_reservation <= 0
        self.free_lesson_reservation = 0
      else
        self.free_lesson_reservation -= 1
      end
      self.save!
    end
  end


  private

    # callback
    def init_settings
      self.settings = StudentSettings.new
    end

    def in_elementary_school?
      grade && grade.in_elementary_school?
    end

    def resolve_organization
      BsCustomer.new(self).resolve_bs_by_address
    end

    # 紹介者に紹介料を支払う
    def journal_student_referral_fee
      reference.student_referral_fees.create!(amount_of_money_received:ChargeSettings.student_referral_fee, referral:self)
    rescue => e
      logger.error e
    end

    def on_leaving
      lessons.future.each do |lesson|
        lesson_cancellation = cancel_lesson(lesson, validation: false)
        if lesson_cancellation.errors.any?
          logger.error "FAILED TO CANCEL LESSON\t#error_messages:#{lesson_cancellation.errors.full_messages}"
        end
      end
      basic_lesson_infos.continuing.each do |basic_lesson_info|
        basic_lesson_info.turn_off_auto_extension
      end
    end

    def on_left
      super
      Mailer.send_mail :membership_cancelled, self
    end

    def on_reviving
      if parent.present?
        # 保護者がアクティブでなければならない
        unless parent.active?
          errors.add :parent, :not_active
        end
      end
      errors.empty?
    end

    # 登録完了時に呼ばれる
    def notify_created
      # 作成された生徒のメールアドレスにメールを送る
      # 保護者が指定されていれば保護者にもメールを送る
      Mailer.send_mail(:student_created, self, password)
    end

    def assign_organization_from_address
      if organization_id.nil?
        if address.present?
          self.organization = resolve_organization
        end
      end
    end

    def on_organization_changed
      logger.info "Student organization changed: #{organization_id_was} to #{organization_id}"
      prev_organization = Organization.find_by_id(organization_id_was)
      reset_coach # この前後でorganization_id_wasの値が変更前の値から変更後の値に変わってしまう。
      #raise coach.inspect
      unless prev_organization.nil?
        Mailer.send_mail(:student_organization_changed, self, prev_organization)
      end
    end

    def create_mail(mail_type, *args)
      StudentMailer.send mail_type, self, *args
    end

    # validation
    def ensure_student_can_leave
      # 授業中、面談中、模試中は退会できない
      if in_lesson?
        errors.add :active, :cannot_leave_because_in_lesson
      end
      if in_meeting?
        errors.add :active, :cannot_leave_because_in_meeting
      end
      if in_exam?
        errors.add :active, :cannot_leave_because_in_exam
      end
    end

    def destroy_all_basic_lesson_infos
      basic_lesson_infos.each do |basic_lesson_info|
        basic_lesson_info.destroy
      end
    end

    # callback
    def update_reference
      user = User.find_by_user_name reference_user_name
      if user
        if user.is_a? Student
          self.reference = user
        elsif user.is_a? HqUser
          self.reference = user
        end
      else
        self.reference = nil
      end
      true
    end

    def update_student_info
      self.student_info.on_student_updated(self)
      true
    end
end

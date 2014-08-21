## -*- encoding: utf-8 -*-
require "date"
class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include UserMeetingMethods
  include SkypeIdHolder
  include QuestionnaireResponder
  include JobOwner
  include Searchable

  class << self
    def subclasses
      # Class.includeded method emits a warning.
      %w(Parent Tutor SpecialTutor Student HqUser BsUser Coach SystemAdmin)
    end

    def mail_address_pattern
      @mail_address_pattern ||= /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    end

    def generate_user_name(retry_count = 0)
      if retry_count > retry_limit
        logger.error "Failed to generate a new user_name after #{retry_limit} times trials."
        nil
      else
        prefix = user_name_prefix
        suffix = user_name_suffix
        user_name = '%s%s' % [prefix, suffix]
        if where(user_name: user_name).exists?
          logger.warn "Generated user name already exists: #{user_name}"
          generate_user_name(retry_count + 1)
        else
          user_name
        end
      end
    end

    def user_name_prefix
      name.downcase[0]
    end

    def user_name_suffix
      year = Date.today.year % 100
      code = Array.new(4){charset.sample}.join
      '%02d%s' % [year, code]
    end

    def generate_password(length=6)
      Array.new(length){password_charset.sample}.join
    end

    def of_organization(organization)
      where(organization_id:organization.id)
    end

    def of_type(cls)
      where(type: cls.name)
    end

    # activeか、この月に辞めた人
    def to_be_charged(year, month)
      period = Account::JournalEntry.period_of_settlement_month(year, month)
      where('status=\'active\' OR left_at BETWEEN :from AND :to', from:period.first.beginning_of_day, to:period.last.end_of_day)
    end

    def throw_error
      raise 'Ouch'
    end

    private

      def retry_limit
        10
      end

      def charset
        @charset ||= ('a'..'z').to_a + ('0'..'9').to_a
      end

      def password_charset
        @password_charset ||= ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      end
  end

  scope :only_active, where(status: 'active')  # 金銭授受を行なうアカウントに絞る
  scope :left, where(status: 'left')
  scope :inactive, where(active: false)
  # 無料会員切り分け
  scope :only_free, where(customer_type: 'free')
  scope :only_premium, where(customer_type: 'premium')
  scope :except_free, where("customer_type != 'free'")
  scope :except_premium, where("customer_type != 'premium'")

  searchable auto_index: false do
    integer :organization_id
    text :user_name
    text :full_name
    boolean :active, using: :active?
    boolean :locked, using: :locked?
    boolean :left, using: :left?
  end

  mount_uploader :photo, PhotoUploader

  belongs_to :organization
  # 自分がメッセージの受け取り側となるテーブル
  has_many :message_recipients, :foreign_key => :recipient_id, :dependent => :delete_all
  has_many :received_messages, :through => :message_recipients, :source => :message,
           :conditions => {message_recipients:{deleted:false}},
           :order => 'messages.created_at DESC'
  has_many :sent_messages, class_name:Message.name, foreign_key: :sender_id,
           :order => 'messages.created_at DESC'
  has_one :address, :as => :addressable, :dependent => :destroy, :autosave => true
  belongs_to :reference, class_name:User.name
  has_many :referrals, :class_name => User.name, :foreign_key => :reference_id, :dependent => :nullify
  has_many :contact_list_items, :uniq => true, :dependent => :delete_all
  has_many :contact_list, :through => :contact_list_items, :source => :contactable, :source_type => User.name, :uniq => true
  has_many :group_contact_list, :through => :contact_list_items, :source => :contactable, :source_type => Organization.name
  has_many :monthly_stats, class_name:UserMonthlyStat.name, :dependent => :destroy
  has_many :journal_entries, class_name:"Account::JournalEntry", :as => :owner
  has_many :monthly_statements, :as => :owner, :dependent => :destroy
  has_one :access_authority, :dependent => :delete
  has_many :payment_veritrans_txns, :dependent => :destroy
  belongs_to :os, class_name:OperatingSystem.name
  has_one :user_operating_system
  has_one :operating_system, :through => :user_operating_system
  has_one :document_camera, :dependent => :destroy
  has_one :membership_cancellation, :dependent => :delete
  has_one :user_operating_system, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable, :validatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :authentication_keys => [:user_name]

  attr_accessor :reference_user_name

  # Setup accessible (or protected) attributes for your model
  attr_accessible :user_name, :email, :password, :password_confirmation, :remember_me,
                  :organization, :nickname, :first_name, :last_name,
                  :photo, :remove_photo,
                  :pc_email, :phone_email, :gmail,
                  :birthday, :sex, :phone_number,
                  :skype_id, :pc_spec, :line_speed,
                  :reference_user_name,
                  :organization_id,
                  :first_name_kana, :last_name_kana,
                  :os_id, :adsl, :upload_speed, :download_speed, :windows_experience_index_score,
                  :birth_place,
                  :driver_license_number,
                  :passport_number,
                  :pc_model_number,
                  :has_web_camera,
                  :free_lesson_limit_number

  attr_accessible :active, :as => :admin

  validates_presence_of :user_name
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :user_name
  validates_inclusion_of :sex, :in => %w(male female), :allow_blank => true
  validates_confirmation_of :password, :if => 'password.present?'
  validates_format_of :user_name, :with => /\A[@.a-zA-Z0-9_-]{1,100}\Z/
  validates_format_of :phone_number, :with => /\A[0-9-]{1,100}\Z/, :allow_blank => true
  validates_inclusion_of :status, :in => %w(new active locked left)
  validate :user_operating_system_is_valid, :if => :user_operating_system

  after_create do
    self.group_contact_list << Headquarter.instance
    if organization && organization != Headquarter.instance
      self.group_contact_list << organization
    end
    logger.account_log("CREATED", log_attributes)
  end

  before_update :on_leaving, :if => :leaving?
  before_update :on_reviving, :if => :reviving?
  after_update  :on_left, :if => :leaving?

  after_update do
    begin
      if active_changed?
        logger.account_log(active? ? 'ACTIVATE' : 'INACTIVATE', log_attributes)
      end
    rescue => e
      logger.error e
    end
  end

  after_destroy do
    logger.account_log('DELETED', log_attributes)
  end

  def root_path
    self.class.name.underscore + "_root_path"
  end

  #
  # アカウント種別判定
  #

  def parent?
    is_a? Parent
  end

  def tutor?
    is_a? Tutor
  end

  def special_tutor?
    is_a? SpecialTutor
  end

  def student?
    is_a? Student
  end

  def bs_user?
    is_a? BsUser
  end

  def bs_owner?
    false
  end

  def coach?
    is_a? Coach
  end

  def hq_user?
    is_a? HqUser
  end

  def system_admin?
    is_a? SystemAdmin
  end

  def guest?
    is_a? Guest
  end

  def parent_of?(user)
    user.present? && user.student? && self == user.parent
  end

  def coach_of?(user)
    false
  end

  def new?
    status == 'new'
  end

  def active?
    status == 'active'
  end

  def left?
    status == 'left'
  end

  def locked?
    status == 'locked'
  end

  def admin? 
    admin == true
  end

  ### 無料会員機能 状態判別
  def free?
    customer_type == 'free' || customer_type == 'request_to_premium' #=> 申請中でもfree判定が出なければならない
  end

  def is_free?
    customer_type == 'free' #=>実際にfreeかどうか問う
  end

  def request_to_premium?
    customer_type == 'request_to_premium'
  end

  def premium?
    customer_type == 'premium'
  end
  ### ここまで

  def yucho_requesting?
    has_credit_card?
    yucho_account_application.present? && yucho_account_application.new?
  end

  def activate
    self.status = 'active'
    self.active = true
    save.tap do |success|
      logger.info "User #{id} is activated." if success
    end
  end

  def deactivate
    self.active = false
    self.status = 'locked'
    save.tap do |success|
      logger.info "User #{id} is deactivated." if success
    end
  end

  def reset_password
    self.password = self.class.generate_password
    save
    self
  end

  # TODO: replace this method
  def full_name
    if first_name.present? || last_name.present?
      I18n.t("common.full_name_format", first_name:first_name, last_name:last_name)
    elsif nickname.present?
      nickname
    else
      self.user_name
    end
  end

  def full_name_kana
    if first_name_kana.present? || last_name_kana.present?
      I18n.t("common.full_name_format", first_name:first_name_kana, last_name:last_name_kana)
    else
      self.user_name
    end
  end

  def name
    self.class.model_name.human + ":" + full_name
  end

  def reference_user_name
    @reference_user_name ||= (reference_id && reference.user_name)
  end

  def age
    @age ||= calculate_age
  end

  def calculate_age
    if birthday
      today = Date.today
      birthday_of_this_year = birthday.change(year:today.year)
      if today < birthday_of_this_year
        today.year - birthday.year - 1
      else
        today.year - birthday.year
      end
    end
  end

  # 年齢から年代を表すIDを返す
  def age_group_id
    case age
    when nil then nil
    when 0...20 then 1
    when 20...30 then 2
    when 30...40 then 3
    else 4
    end
  end

  def address_string
    address && address.serialize
  end

  def emails
    [email, phone_email].compact.uniq
  end

  def send_message(params)
    message = Message.new(title:params[:title], text:params[:text]) do |msg|
      msg.sender = self
      if params[:recipient]
        msg.recipients = [params[:recipient]]
      elsif params[:recipients]
        msg.recipients = params[:recipients]
      else
        raise "recipients are required"
      end
    end
    message.save
    message
  end

  # このユーザ宛にメールを送る
  def send_mail(mail_type, *args)
    logger.info "SENDING MAIL TO #{self.class.name} #{id} #{mail_type}"
    mail = create_mail mail_type, *args
    if mail
      mail.deliver
    end
    logger.info "SENT MAIL #{mail_type} #{args}"
  rescue => e
    logger.error e
  end

  # @param [Message] received_message
  def delete_message(received_message)
    message_recipients.update_all({deleted:true}, message_id:received_message.id, recipient_id:id)
  end

  def latest_lesson_reports
    lesson_reports.order("created_at DESC")
  end

  def latest_lesson_reports_of(users)
    lesson_reports.where("author_id IN (:list) OR student_id IN (:list)", list:users.map(&:id))
  end

  def latest_cs_sheets
    cs_sheets.order("updated_at DESC")
  end

  def active_students
    students.only_active
  end

  def active_tutors
    tutors.only_active
  end

  def active_parents
    parents.only_active
  end

  # 参照できるBSのリストを返す
  def bss
    []
  end

  def search_tutors(key, options={})
    key = SearchUtils.normalize_key key
    search = Tutor.search do
      options.each do |k, v|
        with k, v unless options[:fields] && options[:fields].include?(k)
      end
      if options[:fields]
        fulltext key do
          fields(*options[:fields])
        end
      else
        fulltext key
      end
    end
    search.results
  end

  def search_students(key, options={})
    StudentSearch.new(self).search(key, options)
  end

  def search_users(key, options={})
    key = SearchUtils.normalize_key key
    search = User.search do
      if options[:page]
        paginate :page => options[:page], :per_page => 25
      end
      fulltext key
    end
    search.results
  end

  def search_lesson_reports(key, options={})
    key = SearchUtils.normalize_key key
    search = LessonReport.search do
      options.each do |k, v|
        case k
        when :date
          with(:date).equal_to(v) if v
        when :page
          paginate :page => v, :per_page => (options[:per_page] || 25)
        when :student_id
          with(:student_id).equal_to(v)
        when :student_ids
          with(:student_id).any_of(v)
        else
          # ignore
        end
      end
      fulltext key
    end
    search.results
  end

  def search_basic_lesson_infos(key, options={})
    search = BasicLessonInfo.search do
      options.each do |k, v|
        case k
        when :wday
          with(:wdays, v)
        when :hour
          with(:start_time_hours, v)
        else
          with(k, v)
        end
      end
      fulltext SearchUtils.normalize_key(key)
    end
    search.results
  end

  def update_password(params)
    update_attributes(password:params[:password], password_confirmation:params[:password_confirmation])
  end

  # 引数に与えたユーザの紹介者となる
  def make_referral_to(user)
    if user.reference.blank?
      user.reference = self
      user.save!
    else
      raise "Already referenced by other user."
    end
  end

  # 自分が作りかけた（status == "build") 授業を削除する
  def clear_incomplete_lessons
    lessons.created_by(self).incomplete.destroy_all
  end

  #
  # アカウントの有効・無効
  #

  # 退会する
  def leave!(options={}, &block)
    self.active = false
    self.status = 'left'
    self.reason_to_leave = options[:reason]
    self.left_at = Time.now
    save!
  rescue => e
    if block
      block.call(self)
    else
      raise e
    end
  end

  def leave(reason=nil)
    self.active = false
    self.status = 'left'
    self.reason_to_leave = reason
    self.left_at = Time.now
    save
  end

  # 入会する
  def enroll
    if enrolled_at.blank?
      on_enrolled
      touch(:enrolled_at)
      logger.account_log('ENROLLED', log_attributes)
    end
  end

  # ユーザーをログインできなくする。
  def lock
    self.status = 'locked'
    save
    self
  end

  def unlock
    self.status = 'active'
    save
    self
  end

  def revive!
    unless active?
      self.active = true
      self.status = 'active'
      self.left_at = nil
      save!
    end
    self
  end

  def revive
    unless active?
      self.active = true
      self.status = 'active'
      self.left_at = nil
      self.last_request_at = Time.current # チューターの自動退会防止用
      save
    end
    self
  end

  def member?
    left_at.blank?
  end

  def have_membership?
    membership_cancellation.blank?
  end

  # このユーザがレッスン画面を開ける場合はtrueを返す。
  # チューターと受講者はこのメソッドをオーバーライドしている。
  # モニターとして参加する本部スタッフや教育コーチはここでの定義に従う。
  def can_enter_lesson?(lesson)
    lesson.can_open?
  end

  # 現在受講者がレッスンをキャンセルできる期間であればtrueを返す
  def lesson_cancellation_period?(lesson)
    false
  end

  # ログイン出来る場合にtrueを返さなければならない
  def active_for_authentication?
    super && (active? || new?)
  end

  def representative?
    organization.present? && organization.representative == self
  end

  ################################################################
  # 権限
  ################################################################

  def can_cancel?(lesson)
    false
  end

  def can_cancel_optional_lesson_for_month?(time)
    monthly_stats_for(time.year, time.month).optional_lesson_cancellation_count < optional_lesson_cancellation_limit_per_month
  end

  def can_cancel_basic_lesson_for_month?(time)
    monthly_stats_for(time.year, time.month).basic_lesson_cancellation_count < basic_lesson_cancellation_limit_per_month
  end

  ################################################################
  # 統計
  ################################################################
  def monthly_stats_for(year, month)
    monthly_stats.find_or_create_by_year_and_month(year, month)
  end

  def optional_lesson_cancellation_limit_per_month
    0
  end

  def basic_lesson_cancellation_limit_per_month
    0
  end

  # 自分がレッスンをキャンセルした時に呼び出される。
  # 統計情報を更新する
  def on_lesson_cancelled(lesson)
    update_monthly_stats_for_lesson_cancellation(lesson)
  end

  def update_monthly_stats_for_lesson_cancellation(lesson)
    if lesson.is_a?(OptionalLesson)
      monthly_stats_for(lesson.start_time.year, lesson.start_time.month).increment!(:optional_lesson_cancellation_count)
    elsif lesson.is_a?(BasicLesson)
      monthly_stats_for(lesson.start_time.year, lesson.start_time.month).increment!(:basic_lesson_cancellation_count)
    else
      logger.error "Unexpected argument #{lesson}"
    end
  rescue => e
    logger.error e
  end

  ################################################################
  # 会計
  ################################################################

  # 毎月発生する科目データを作成する
  def update_monthly_journal_entries!(year, month)
    # 実際の処理はサブクラスで
  end

  def update_monthly_result!(year, month)
    monthly_stat = monthly_stats.find_or_create_by_year_and_month(year, month)
    monthly_stat.update_with_journal_entries
    monthly_stat
  end

  # 月次集計を作成・更新する
  def update_monthly_statement_for(year, month)
    monthly_statement = monthly_statement_of_month(year, month)
    monthly_statement.calculate
    monthly_statement
  end

  def monthly_statement_of_month(year, month)
    monthly_statements.find_or_create_by_year_and_month(year, month)
  end

  def ready_to_pay?
    false
  end

  ################################################################
  # 通知
  ################################################################
  def notify(signal, *args)
    logger.info("NOTIFIED:#{signal}")
  end

  ################################################################
  # 課金関連
  ################################################################
  def credit_card_register(card_info = {})
    card_info = {
      number: '',
      expire: 'MM/YY',
      security_code: '',  # optional
    }.merge(card_info)
    PaymentVeritransTxn.authorize(self, card_info)
  end

  def payment(amount)
    last_payment = payment_veritrans_txns.available.last
    raise PaymentNotRegisteredError if last_payment.blank?
    last_payment.payment(amount)
  rescue => e
    raise PaymentFailedError, "user_name is #{user_name}: #{e.message}", e.backtrace
  end

  ### ユーザーが登録中のクレジットカード番号を取得
  def get_available_card_number
    last_payment = payment_veritrans_txns.available.last
    raise PaymentNotRegisteredError if last_payment.blank?
    res = last_payment.get_order_information
    card_number = res.order_infos.order_info[0].transaction_infos.transaction_info[0].proper_transaction_info.req_card_number
    # クレジットカード番号表示用(4桁区切り)
    card_number = card_number.slice(0, 4) + ' ' + card_number.slice(4, 2) + '**' + ' ' + '****' + ' ' + '**' + card_number.slice(7,2)
    card_number
  rescue => e
    #card_number = '情報が取得できませんでした。'
    card_number = ''
    #raise PaymentNotRegisteredError, "user_name is #{user_name}: #{e.message}", e.backtrace
  end

  ################################################################
  # PC スペック等
  ################################################################

  # スペックデータをコピーする
  def spec=(src)
    #:os_id, :adsl, :upload_speed, :download_speed, :windows_experience_index_score
    self.os_id = src.os_id
    self.adsl = src.adsl
    self.upload_speed = src.upload_speed
    self.download_speed = src.download_speed
    self.windows_experience_index_score = src.windows_experience_index_score
  end

  # 退会申込時のバリデーション
  def validate_membership_cancellation(membership_cancellation)
    # 実装はサブクラス
  end

  # 退会申込みの直前にMembershipCancellationから呼ばれる
  def on_canceling_membership(membership_cancellation)
    true
  end

  def busy?
    false
  end

  def registered_day
    created_at.to_date
  end

  # システムを使っていない日数
  # @return (Integer) 日数
  def absent_days
    from = (last_request_at || created_at).to_date
    (Date.today - from).to_i
  end

  # チューターだけニックネームの表示に「先生」などとつけたりするので、
  # サブクラスでカスタマイズできるように別メソッドにした。
  def nickname2
    nickname
  end

  def role
    @role ||= resolve_role
  end

  def resolve_role
    t = self.class
    if t <= Student
      :student
    elsif t <= Tutor
      :tutor
    elsif t <= Parent
      :parent
    elsif t <= BsUser
      :bs_user
    elsif t <= HqUser
      :hq_user
    elsif t <= Guest
      :guest
    else
      nil
    end
  end

  #無料体験レッスンをすべて消費している場合trueを返す
  def all_free_lesson_taken
    all_taken_flg = false
    if self.free?
      free_lesson_reservation = self.free_lesson_reservation
      free_limit = self.free_lesson_limit_number
      if free_lesson_reservation >= free_limit
        all_taken_flg = true
      end
    end
    return all_taken_flg
  end

  #渡された日付が無料体験期限以内であればtrueを返す
  def check_if_before_expiration_date date
    available_flg = true
    if self.free?
      target_day = Date.new(date.year,date.month,date.day)
      expiration = free_lesson_expiration_date
      becoming_free_user_day = self.date_of_becoming_free_user
      expiration_day = Date.new(becoming_free_user_day.year,becoming_free_user_day.month,becoming_free_user_day.day)
      expiration_day = expiration_day+expiration
      if target_day <= expiration_day
        available_flg = true
      else
        available_flg = false
      end
    end
    return available_flg
  end

  #会員種別プルダウン作成用
  def customer_type_for_select_box
    {
      "会員種別"=>nil,
      "無料会員"=>"free",
      "一般会員"=>"premium",
      "一般会員移行中"=>"request_to_premium"
    }
  end

  #受け取ったgrade（学年）に一致する会員IDをすべて返す
  def searching_users_by_grade grade
    grade_id = Grade.new.get_id_from_code(grade)
    student_infomation = StudentInfo.where(grade_id: grade_id)
    user_ids = []
    student_infomation.each do |info|
      user_ids.push(info.student_id)
    end
    user_ids.sort!
  end

  private

    # 退会処理後に呼ばれる
    def on_left
      logger.account_log('LEFT', log_attributes)
    end

    def on_leaving
    end

    def on_reviving
    end

    # 入会した時に呼ばれる
    def on_enrolled
    end

    def log_attributes
      {id:id, user_name:user_name, type:type}
    end

    def leaving?
      status_changed? && left?
    end

    def reviving?
      status_changed? && active?
    end

    def create_mail(mail_type, *args)
      logger.info 'Not implemented'
      nil
    end

    def user_operating_system_is_valid
      unless user_operating_system.valid?
        user_operating_system.errors.full_messages.each do |msg|
          errors.add(:user_operating_system, :validation_error, msg: msg)
        end
      end
    end
end

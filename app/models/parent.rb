class Parent < User
  include BankAccountOwner
  include Payer
  include MembershipManagement
  include Searchable
  include EmailChangeNotifier

  class << self
    def for_list
      includes(:address, :students)
    end
  end

  searchable auto_index: false do
    boolean :active, using: :active?
    boolean :locked, using: :locked?
    boolean :left,   using: :left?

    integer :organization_ids, :multiple => true do
      student_organizations.map(&:id)
    end

    integer :id
    string :customer_type
    text :full_name
    text :full_name_kana
    string :sex
    text :emails
    text :phone_number
    text :address do
      address && address.serialize
    end

    string :payment_method do
      payment_method && payment_method.class.name
    end
  end

  has_many :students, :dependent => :destroy
  has_one :registration_form, class_name:ParentRegistrationForm.name, :foreign_key => :user_id, :dependent => :destroy

  validates_presence_of :address, :email, :phone_number, :first_name, :last_name,
                        :sex
  validates_presence_of :password, :on => :create
  validates_presence_of :payment_method, :on => :create
  validates_format_of :email, :with => Parent.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?
  validates_uniqueness_of :nickname, allow_blank: true, message: :taken



  before_create do
    if organization.blank?
      self.organization = BsCustomer.new(self).resolve_bs_by_address
    end
  end

  after_update :on_status_changed, :if => :status_changed?

  def root_path
    pa_root_path
  end

  def interviews
    Interview.where("user1_id=:id OR user2_id=:id", id:id)
  end

  # BSを変更する
  def change_bs!(bs)
    self.organization = bs
    save!
  end

  # 受講者が所属する教育コーチの一覧を返す。
  # 本部が教育コーチの場合はそれも含む。
  def bss
    student_organizations
  end

  def student_organizations
    Organization.where(id: students.map(&:organization_id).compact.uniq)
  end

  def organization_emails
    student_organizations.map(&:emails).uniq
  end

  def ready_to_pay?
    has_credit_card? || bank_account.present?
  end

  def validate_membership_cancellation(membership_cancellation)
    if students.any?{|student| student.busy?}
      membership_cancellation.errors.add :user, I18n.t('parent.errors.student_is_busy')
    end
  end

  def on_canceling_membership(membership_cancellation)
    # 管理している受講者を退会する
    students.each do |student|
      if student.membership_cancellation.blank?
        mc = student.create_membership_cancellation(reason: I18n.t('student.membership_cancellation.because_parent_is_leaving'))
        if mc.errors.any?
          membership_cancellation.errors.add :user, I18n.t('parent.errors.student_is_busy')
        end
      end
    end
    membership_cancellation.errors.empty?
  end

  private

    # 保護者自身と、保護者が管理している生徒を退会扱いにする。
    def on_leaving
      if make_students_leave
        Mailer.send_mail :membership_cancelled, self
        true
      else
        false
      end
    end

    def make_students_leave
      students.each do |student|
        unless student.leave
          if errors[:students].empty?
            errors.add :students, :cannot_leave
          end
        end
      end
      errors.empty?
    end

    def notify_created
      Mailer.send_mail(:parent_created, self, password)
    end

    def create_mail(mail_type, *args)
      ParentMailer.send mail_type, self, *args
    end

    def on_status_changed
      if active?
      end
    end

    def on_email_changed
      delay.send_mail(:user_email_changed)
    end
end

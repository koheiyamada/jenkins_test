class Bs < Organization
  #include Ledgerable
  include BankAccountOwner
  include Searchable

  class << self
    def search_by_keyword(keyword, options)
      search = Bs.search do
        if options[:page].present?
          paginate :page => options[:page], :per_page => 25
        end
        if options[:active].present?
          with :active, options[:active]
        end
        fulltext SearchUtils.normalize_key(keyword)
      end
      search.results
    end

    def search_by_postal_code(code, &block)
      code = ZipCode.normalize code
      logger.debug "Bs.search_by_postal_code #{code}"
      zip_code = ZipCode.find_by_code(code)
      logger.debug zip_code
      if zip_code
        case zip_code.area_codes.count
        when 0
          Headquarter.instance
        when 1
          where(active: true, area_code: zip_code.area_codes.first.code).first || (block && block.call(code))
        else
          Headquarter.instance
        end
      elsif block
        logger.debug 'Postal code not found: return with block'
        block.call(code)
      else
        logger.debug 'Postal code not found: return nil'
        nil
      end
    end
  end

  scope :left, where(active:false)

  has_one :app_form, class_name:BsAppForm.name, :dependent => :destroy
  has_many :bs_users, :foreign_key => :organization_id, :dependent => :destroy
  has_many :coaches, :foreign_key => :organization_id
  belongs_to :representative, class_name:BsUser.name, :validate => true

  # 会計科目
  has_many :bs_id_management_fees, class_name:Account::BsIdManagementFee.name, :as => :owner
  has_many :bs_textbook_rental_fees, class_name:Account::BsTextbookRentalFee.name, :as => :owner
  has_many :lesson_sales_amounts, class_name:Account::LessonSaleAmount.name, :as => :owner

  attr_accessible :area_code
  attr_accessible :active, :left_at, as: :admin

  validates_presence_of :email, :phone_number, :address
  validates_format_of :phone_number, :with => /\A[0-9-]{1,100}\Z/, :allow_blank => true

  before_create do
    if area_code.blank? && address.present?
      postal_code = PostalCode.search_by_postal_code(address.postal_code)
      self.area_code = postal_code.area_code.code if postal_code && postal_code.area_code.present?
    end
  end

  before_update  :deactivate_bs_users,     if: :deactivating?
  before_update  :move_all_students_to_hq, if: :deactivating?
  before_destroy :move_all_students_to_hq

  searchable auto_index: false do
    text :name
    text :area_code
    text :email
    text :phone_number
    text :address do
      address && address.serialize
    end
    text :representative do
      representative && representative.full_name
    end
    boolean :active
    time :created_at
    time :left_at
    integer :students_count do
      students.count
    end
  end

  def new_representative
    build_representative do |user|
      user.user_name = BsUser.generate_user_name
      user.password = BsUser.generate_password

      user.email = email
      user.phone_number = phone_number
      user.address = address

      if app_form.present?
        app_form.fill_bs_user_fields(user)
      end
    end
  end

  def user_name
    representative && representative.user_name
  end

  def owner
    representative
  end

  def create_member(params)
    params[:user_name] ||= BsUser.generate_user_name
    params[:password] ||= BsUser.generate_password
    user = BsUser.create!(params) do |u|
      u.organization = self
    end
    # 生パスワードを返すためにわざとユーザデータをロードしている。
    users.each do |u|
      u.password = params[:password]
    end
    user
  end

  def textbook_users
    students.with_textbook_usage
  end

  def contactable_members
    users.limit(1)
  end

  def message_recipients
    bs_users
  end

  def messages_to_coaches
    Message.joins(:message_recipients).where(message_recipients: {recipient_id: coach_ids})
  end

  def student_received_messages
    Message.to_users(student_ids)
  end

  # 退会する
  def leave!
    if active?
      self.active = false
      save!
    end
  end

  def leave
    update_attributes({active: false, left_at: Time.current}, as: :admin)
  end

  def deactivating?
    active_changed? && !active?
  end

  def activate
    unless active?
      update_attribute :active, true
    end
  end

  def move_all_students_to(organization)
    if organization != self
      students.find_each do |student|
        student.change_bs(organization)
      end
    end
  end

  def move_all_students_to_hq
    move_all_students_to Headquarter.instance
  end

  def set_representative(bs_user)
    if bs_user.is_a?(BsUser) && bs_user.organization_id == id
      update_attribute :representative_id, bs_user.id
    end
  end

  ################################################################
  # 会計
  ################################################################

  def update_monthly_journal_entries!(year, month)
    transaction do
      # BS ID管理費
      if bs_id_management_fees.of_month(year, month).empty?
        bs_id_management_fees.create! do |entry|
          entry.year = year
          entry.month = month
          entry.amount_of_payment = ChargeSettings.bs_id_management_fee
        end
      end
      # レッスン料の取り分を計算する
      monthly_result = update_monthly_result!(year, month)
      lesson_sales_amounts.of_month(year, month).destroy_all
      lesson_sales_amounts.create! do |entry|
        entry.year = year
        entry.month = month
        entry.amount_of_money_received = monthly_result.bs_share_of_lesson_sales
      end
    end
  end

  def reset_area_code
    zip_code = ZipCode.of_code(address.postal_code)
    if zip_code
      area_code = zip_code.area_codes.first
      if area_code
        update_attribute :area_code, area_code.code
      else
        logger.warn "Area code for postal_code #{address.postal_code} not found."
      end
    else
      logger.warn "Area code for postal_code #{address.postal_code} not found."
    end
    self
  end

  def monthly_statement_of_month(year, month)
    monthly_statements.find_or_create_by_year_and_month(year, month)
  end

  private

    def deactivate_bs_users
      bs_users.only_active.all? do |bs_user|
        bs_user.leave(I18n.t('messages.because_bs_is_deactivated')).tap do |success|
          logger.error "id: #{bs_user.id}: #{bs_user.errors.full_messages}" unless success
        end
      end
    end
end

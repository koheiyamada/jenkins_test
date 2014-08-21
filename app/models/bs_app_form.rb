class BsAppForm < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  include PcSpecHolder
  include QuestionnaireResponder
  include FormWithOs
  include Searchable

  searchable auto_index: false do
    string :status
    text :email
    text :phone_number
    text :corporate_name
    text :full_name
    text :full_name_kana
    text :reason_for_applying
    text :job_history
    text :preferred_areas
    time :created_at
  end

  class Status
    NEW         = 'new'
    REJECTED    = 'rejected'
    ACCEPTED    = 'accepted'
  end

  scope :confirmed, where(confirmed: true)
  scope :unprocessed, where(status: Status::NEW)
  scope :processed, where("status != 'new' OR bs_id IS NOT NULL")

  has_one :address, :as => :addressable, dependent: :destroy
  belongs_to :bs_user
  belongs_to :bs
  belongs_to :os, class_name:OperatingSystem.name

  attr_accessible :corporate_name, :email, :line_speed, :first_name, :last_name,
                  :pc_spec, :phone_number, :reason_for_applying, :confirmed,
                  :address_attributes, :address, :representative_birthday, :representative_sex,
                  :photo, :photo_cache,
                  :first_name_kana, :last_name_kana,
                  :email_confirmation,
                  :high_school, :college, :department, :graduate_college,
                  :major, :job_history, :use_document_camera,
                  :birth_place,
                  :driver_license_number,
                  :passport_number,
                  :pc_model_number,
                  :has_web_camera,
                  :preferred_areas,
                  :interview_datetime_1, :interview_datetime_2, :interview_datetime_3

  attr_accessor :email_confirmation

  # アンケートの回答を保持する
  attr_accessor :how_to_find
  attr_accessible :how_to_find
  attr_reader :how_to_find_form

  validates_presence_of :first_name, :last_name, :email,
                        :first_name_kana, :last_name_kana,
                        :job_history, :reason_for_applying,
                        :high_school, :birth_place,
                        :phone_number,
                        :representative_sex

  validates_inclusion_of :status, :in => %w(new accepted rejected)
  validates_format_of :email, :with => BsUser.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?
  validates_confirmation_of :email
  validate :questionnaire_is_answered
  validate :address_is_valid

  before_validation :parse_questionnaire_answers
  before_save do
    if bs.present?
      self.status = "accepted"
    end
  end

  after_save :save_questionnaire_answers

  after_update do
    if confirmed_changed? && confirmed?
      Mailer.send_mail(:bs_app_form_accepted, self)
    end
  end

  def new?
    status == 'new'
  end

  def accepted?
    status == 'accepted'
  end

  def rejected?
    status == 'rejected'
  end

  def reject!
    self.status = 'rejected'
    save!
  end

  def reject
    update_attribute :status, 'rejected'
  end

  def confirm!
    update_attribute :confirmed, true
    touch(:confirmed_at)
  end

  def create_bs_and_bs_user!
    return bs_user if bs_user.present?

    transaction do
      new_bs = create_bs do |new_bs|
        new_bs.name = corporate_name || full_name
        new_bs.address = address
        new_bs.email = email
        new_bs.phone_number = phone_number
      end

      bs_user = new_bs.bs_users.create! do |user|
        user.user_name = BsUser.generate_user_name
        user.password = BsUser.generate_password
        user.email = email
        user.phone_number = phone_number
        user.first_name = first_name
        user.last_name = last_name
        user.first_name_kana = first_name_kana
        user.last_name_kana = last_name_kana
        user.address = address
        user.photo = photo
        user.spec = self
        user.sex = representative_sex
        user.birthday = representative_birthday
        user.birth_place = birth_place
      end

      self.bs_user = bs_user
      save!

      bs_user
    end
  end

  def new_bs
    Bs.new do |bs|
      bs.name = corporate_name || full_name
      bs.address = address || Address.new
      bs.email = email
      bs.phone_number = phone_number
    end
  end

  def full_name
    I18n.t("common.full_name_format", last_name:last_name, first_name:first_name)
  end

  def full_name_kana
    I18n.t("common.full_name_format", last_name:last_name_kana, first_name:first_name_kana)
  end

  def load_questionnaire_answers
    answer = self.answers.to_question(:how_to_find).first
    @how_to_find = HowToFindQuestion.answer_to_hash(answer)
    @how_to_find_form = HowToFindQuestionForm.new(self)
  end

  def fill_bs_user_fields(user)
    user.first_name      = first_name
    user.last_name       = last_name
    user.first_name_kana = first_name_kana
    user.last_name_kana  = last_name_kana
    user.photo           = photo
    user.spec            = self
    user.birth_place     = birth_place
    user.driver_license_number = driver_license_number
    user.passport_number = passport_number
    user.pc_model_number = pc_model_number
    user.sex             = representative_sex
    user.birthday        = representative_birthday
    user.build_user_operating_system{|uos| fill_user_operating_system(uos)}
  end

  private

    def address_is_valid
      if address.present?
        if address.invalid?
          errors.add :address, :not_given
        end
      end
    end

    def questionnaire_is_answered
      if how_to_find_form && how_to_find_form.invalid?
        errors.add :how_to_find, :not_answered
      end
    end

    def parse_questionnaire_answers
      if how_to_find.present?
        @how_to_find_form = HowToFindQuestionForm.new(self, how_to_find)
      end
    end

    def save_questionnaire_answers
      if how_to_find_form.present?
        answers.destroy_all # 既存のデータを破棄する
        how_to_find_form.create_answer
      end
      true
    rescue => e
      logger.error e
      false
    end

    def driver_license_number_or_passport_number_is_given
      if driver_license_number.blank? && passport_number.blank?
        errors.add :driver_license_number, :or_passport_number_is_required
      end
    end
end

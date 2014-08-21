# coding:utf-8

class TutorAppForm < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  include PcSpecHolder
  include SkypeIdHolder
  include QuestionnaireResponder

  scope :confirmed, where(confirmed:true)
  scope :under_application, where(tutor_id: nil, confirmed: true).where('status != ?', 'rejected')
  scope :processed, where('tutor_id IS NOT NULL OR status = ?', 'rejected')

  belongs_to :tutor
  has_one :current_address, :as => :addressable
  has_one :hometown_address, :as => :addressable
  belongs_to :os, class_name:OperatingSystem.name

  attr_accessor :pc_mail_confirmation

  # アンケートの回答を保持する
  attr_accessor :how_to_find
  attr_accessible :how_to_find
  attr_reader :how_to_find_form

  attr_accessible :activities, :birth_place, :confirmed,
                  :do_volunteer_work, :first_name, :free_description, :high_school,
                  :job_history, :last_name, :nickname, :pc_mail, :phone_mail,
                  :phone_number, :photo, :photo_cache, :skype_id, :status,
                  :teaching_experience, :teaching_results,
                  :undertake_group_lesson, :year_of_admission,
                  :year_of_graduation,
                  :first_name_kana, :last_name_kana,
                  :sex, :graduated, :grade,
                  :college, :department, :faculty,
                  :graduate_college, :graduate_college_department, :major,
                  :student_number,
                  :driver_license_number,
                  :passport_number,
                  :pc_model_number,
                  :jyuku_history,
                  :favorite_books,
                  :birthday,
                  :grades_and_subjects,
                  :pc_spec,
                  :line_speed,
                  :use_document_camera,
                  :reference,
                  :special_tutor,
                  :special_tutor_wage,
                  :interview_datetime_1,
                  :interview_datetime_2,
                  :interview_datetime_3,
                  :pc_mail_confirmation,
                  :has_web_camera,
                  :current_address, :hometown_address,
                  :custom_os_name

  validates_presence_of :first_name, :last_name,
                        :first_name_kana, :last_name_kana,
                        :nickname,
                        :skype_id, :pc_mail, :phone_number,
                        :current_address,
                        :sex,
                        :birth_place, :high_school,
                        :free_description
  validates_presence_of :nickname, :on => :create
  validates_inclusion_of :status, :in => %w(new under_application rejected accepted)
  #validates_confirmation_of :pc_mail
  validates_format_of :pc_mail, :with => Tutor.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?
  validates_numericality_of :special_tutor_wage, :only_integer => true, :greater_than_or_equal_to => 0, :less_than => 100000, :if => :special_tutor?
  validate :current_address_is_valid
  validate :questionnaire_is_answered
  #validate :driver_license_number_or_passport_number_is_given
  validate :ensure_interview_dates_are_valid, :unless => :confirmed?
  validates_numericality_of :upload_speed, :allow_blank => true, :greater_than_or_equal_to => 2, :message => :must_be_2mbps
  validates_numericality_of :download_speed, :allow_blank => true, :greater_than_or_equal_to => 2, :message => :must_be_2mbps
  validates_presence_of :custom_os_name, :if => :custom_os?

  before_validation :parse_questionnaire_answers

  before_save do
    if tutor_id_changed? && tutor_id.present?
      self.status = 'accepted'
    end
  end

  after_save :save_questionnaire_answers

  after_update do
    if confirmed_changed? && confirmed?
      Mailer.send_mail(:tutor_app_form_accepted, self)
    end
  end

  def new?
    status == 'new'
  end

  def rejected?
    status == 'rejected'
  end

  def accepted?
    status == 'accepted'
  end

  def processed?
    accepted? || rejected?
  end

  def current_address_attributes=(attrs)
    self.current_address = Address.create(attrs)
  end

  def hometown_address_attributes=(attrs)
    self.hometown_address = Address.create(attrs)
  end

  def full_name
    I18n.t("common.full_name_format", last_name:last_name, first_name:first_name)
  end

  def full_name_kana
    I18n.t("common.full_name_format", last_name:last_name_kana, first_name:first_name_kana)
  end

  def create_account!
    transaction do
      self.tutor = new_tutor
      save! # これをやっておかないと関連が保存されない
      tutor
    end
  end

  # このチューター新規登録フォームから新規アカウントを作成
  def new_tutor
    tutor_class.new do |tutor|
      tutor.user_name = Tutor.generate_user_name
      tutor.password = Tutor.generate_password
      tutor.password_confirmation = tutor.password
      fill_tutor_fields tutor
    end
  end

  def tutor_class
    special_tutor? ? SpecialTutor : Tutor
  end

  def reject!
    self.status = 'rejected'
    save!
  end

  def reject
    self.status = 'rejected'
    save
  end

  def confirm!
    update_attribute(:confirmed, true)
    touch(:confirmed_at)
  end

  def load_questionnaire_answers
    answer = self.answers.to_question(:how_to_find).first
    @how_to_find = HowToFindQuestion.answer_to_hash(answer)
    @how_to_find_form = HowToFindQuestionForm.new(self)
  end

  def interview_datetimes
    [interview_datetime_1, interview_datetime_2, interview_datetime_3]
  end

  private

    def current_address_is_valid
      if current_address.present?
        if current_address.invalid?
          errors.add :current_address, :not_given
        end
      end
    end

    def parse_questionnaire_answers
      if how_to_find.present?
        @how_to_find_form = HowToFindQuestionForm.new(self, how_to_find)
      end
    end

    def questionnaire_is_answered
      if how_to_find_form && how_to_find_form.invalid?
        errors.add :how_to_find, :not_answered
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

    def ensure_interview_dates_are_valid
      # 三日後以降であること
      if any_of_interview_datetime_is_within_three_days?
        errors.add :interview_datetimes, :must_be_three_days_or_more_from_today
      end
    end

    def any_of_interview_datetime_is_within_three_days?
      interview_datetimes.compact.any? do |t|
        t < 3.days.from_now.beginning_of_day
      end
    end

    def custom_os?
      os.present? && os.unknown?
    end

    def fill_tutor_fields(tutor)
      tutor.email = pc_mail
      tutor.birthday = birthday
      tutor.phone_number = phone_number
      tutor.nickname = nickname
      tutor.current_address = current_address || CurrentAddress.new
      tutor.hometown_address = HometownAddress.new
      tutor.organization = Headquarter.instance # チューターは本部に所属する
      tutor.first_name = first_name
      tutor.last_name = last_name
      tutor.first_name_kana = first_name_kana
      tutor.last_name_kana = last_name_kana
      tutor.photo = photo
      tutor.sex = sex
      tutor.pc_spec = pc_spec
      tutor.line_speed = line_speed
      tutor.skype_id = skype_id
      tutor.spec = self
      if reference.present?
        tutor.reference_user_name = reference
      end
      tutor.birth_place = birth_place
      tutor.driver_license_number = driver_license_number
      tutor.passport_number = passport_number
      tutor.pc_model_number = pc_model_number
      tutor.has_web_camera = has_web_camera

      tutor.info = TutorInfo.new do |info|
        fill_tutor_info_fields info
      end

      if special_tutor?
        tutor.price = TutorPrice.new_special_tutor_price(special_tutor_wage)
      else
        tutor.price = TutorPrice.new_default_price
      end

      tutor.build_user_operating_system{|uos| fill_user_operating_system(uos)}
    end

    def fill_tutor_info_fields(info)
      info.pc_mail = pc_mail
      info.phone_mail = phone_mail
      info.college = college
      info.department = department
      info.faculty = faculty
      info.graduated = graduated
      info.grade = grade
      info.graduate_college = graduate_college
      info.graduate_college_department = graduate_college_department
      info.major = major
      info.high_school = high_school
      info.activities = activities
      info.teaching_experience = teaching_experience
      info.teaching_results = teaching_results
      info.free_description = free_description
      info.do_volunteer_work = do_volunteer_work
      info.undertake_group_lesson = undertake_group_lesson
      info.special_tutor = special_tutor
      info.student_number = student_number
      info.jyuku_history = jyuku_history
      info.favorite_books = favorite_books
    end

    def fill_user_operating_system(uos)
      uos.operating_system = os
      uos.custom_os_name = custom_os_name
    end
end

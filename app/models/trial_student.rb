class TrialStudent < Student
  class << self
    def user_name_prefix
      'guest_'
    end

    def new_with_default_values
      new do |s|
        s.send :populate_fields
      end
    end
  end

  before_validation :populate_default_values, on: :create
  before_create{self.status = 'active'}
  before_destroy :delete_lessons, prepend: true

  def trial?
    true
  end

  def ready_to_pay?
    true
  end

  def can_cancel?(lesson)
    false
  end

  def root_path
    ts_root_path
  end

  def on_monthly_charge_updated(year, month)
    # do nothing
  end

  def should_write_cs_sheet?(lesson)
    false
  end

  def afford_to_take_lesson_from?(tutor, date, units=1)
    true
  end

  private

    def populate_default_values
      populate_fields
      populate_associations
      self
    end

    def populate_fields
      v = default_values
      self.user_name       = TrialStudent.generate_user_name if user_name.blank?
      self.password        = TrialStudent.generate_password if password.blank?
      self.email           = v['email'] if email.blank?
      self.nickname        = v['nickname'] if nickname.blank?
      self.first_name      = v['first_name'] if first_name.blank?
      self.last_name       = v['last_name'] if last_name.blank?
      self.first_name_kana = v['first_name_kana'] if first_name_kana.blank?
      self.last_name_kana  = v['last_name_kana'] if last_name_kana.blank?
      self.phone_number    = v['phone_number'] if phone_number.blank?
      self.birthday        = v['birthday'] if birthday.blank?
      self.sex             = v['sex'] if sex.blank?
      self
    end

    def populate_associations
      self.address         = Address.new_dummy
      self.grade           = Grade.default
      self.payment_method  = DummyPaymentMethod.new
      self
    end

    def default_values
      @default_values ||= load_default_values
    end

    def load_default_values
      YAML.load_file(Rails.root.join('config', 'trial_student.yml'))[Rails.env]
    end

    def delete_lessons
      lessons.each(&:destroy)
    end
end

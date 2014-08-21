class TutorInfo < ActiveRecord::Base

  class << self
    def lesson_skip_count_limit
      3
    end
  end

  belongs_to :tutor
  has_one :current_address, :as => :addressable
  has_one :hometown_address, :as => :addressable
  accepts_nested_attributes_for :current_address
  accepts_nested_attributes_for :hometown_address

  attr_accessible :pc_mail, :phone_mail, :photo,
                  :current_address_attributes, :hometown_address_attributes,
                  :college, :department, :year_of_admission, :year_of_graduation, :activities,
                  :teaching_experience, :teaching_results, :free_description,
                  :high_school, :birth_place,
                  :do_volunteer_work, :undertake_group_lesson,
                  :graduated, :grade, :graduate_college, :graduate_college_department, :major,
                  :special_tutor, :use_document_camera,
                  :hobby,
                  :student_number,
                  :driver_license_number,
                  :passport_number,
                  :pc_model_number,
                  :jyuku_history,
                  :favorite_books,
                  :faculty

  validates_inclusion_of :status, :in => %w(new regular)

  before_update do
    check_upgrade
  end

  before_save :assign_special_tutor_status
  before_save :fix_average_cs_point

  def current_address_attributes=(attrs)
    self.current_address = Address.create(attrs)
  end

  def hometown_address_attributes=(attrs)
    self.hometown_address = Address.create(attrs)
  end

  def new?
    status == 'new'
  end

  def become_regular!
    self.status = 'regular'
    self.save!
  end

  def become_regular
    self.status = 'regular'
    self.save
    self
  end

  def become_normal
    self.special_tutor = false
    save
    self
  end

  def become_beginner
    update_column :status, 'new'
    self
  end

  def regular?
    status == 'regular'
  end

  def full_name
    I18n.t('common.full_name_format', last_name:last_name, first_name:first_name)
  end

  # 時間単位基本報酬改定ポイントを消費して時給を上げる
  def upgrade(use_all=false)
    if upgrade_points > 0
      n = use_all ? upgrade_points : 1
      transaction do
        decrement!(:upgrade_points, n)
        tutor.price.upgrade!(n)
        logger.upgrade_log("UPGRADED", tutor.price.attributes)
        true
      end
    else
      false
    end
  end

  def on_cs_sheet_created(cs_sheet)
    if cs_sheet.good_score?
      increment!(:good_cs_score_count)
      if good_cs_score_upgrade_condition_satisfied?
        add_upgrade_point("24 CS SHEETS WITH HIGH SCORE")
      end
    end
  end

  # 昇給ポイントを加算する。
  # スペシャルチューターは昇給ポイントが増えない
  def add_upgrade_point!(reason="")
    unless tutor.special?
      add_upgrade_point(reason)
      save!
    end
  end

  private

    # 昇給ポイントを加算するが保存はしない。
    def add_upgrade_point(reason='')
      increment(:upgrade_points)
      logger.upgrade_log("UPGRADE_POINT_GAINED", tutor_id:tutor.id, reason:reason)
    end

    # 時間単位基本報酬改定ポイント発生をチェックする
    def check_upgrade
      if total_lesson_units_changed?
        # 累計レッスン単位数が88の倍数の時に時間単位基本報酬改定ポイントが加算される
        if total_lesson_units_upgrade_condition_satisfied?
          add_upgrade_point("FINISHED 88 LESSONS")
        end
      end
    end

    def good_cs_score_upgrade_condition_satisfied?
      good_cs_score_count > 0 && good_cs_score_count % 24 == 0
    end

    def total_lesson_units_upgrade_condition_satisfied?
      total_lesson_units > 0 && total_lesson_units % 88 == 0
    end

    def assign_special_tutor_status
      if tutor && tutor.special?
        self.status = 'regular'
      end
    end

    def fix_average_cs_point
      if average_cs_points.blank?
        self.average_cs_points = 0
      end
    end
end

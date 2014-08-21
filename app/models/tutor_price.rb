class TutorPrice < ActiveRecord::Base
  belongs_to :tutor
  attr_accessible :hourly_wage

  class << self
    def new_default_price
      new do |price|
        price.hourly_wage = beginner_tutor_default_hourly_wage
      end
    end

    # 仮登録チューターの１単位あたりのレッスン料金を返す。
    # 引数に時給上乗せ分を反映させられる
    def beginner_tutor_lesson_unit_fee(grade_premium = 0)
      (lesson_fee_from_hourly_wage(regular_tutor_default_hourly_wage + grade_premium) * 0.7).floor
    end

    def graduated_beginner_tutor_lesson_unit_fee(grade_premium = 0)
      (lesson_fee_from_hourly_wage(graduated_regular_tutor_default_hourly_wage + grade_premium) * 0.7).floor
    end

    def beginner_tutor_default_hourly_wage
      ChargeSettings.tutor_default_hourly_wage
    end

    def graduated_regular_tutor_default_hourly_wage
      ChargeSettings.graduated_regular_tutor_default_hourly_wage
    end

    def regular_tutor_default_hourly_wage
      ChargeSettings.regular_tutor_default_hourly_wage
    end

    def new_special_tutor_price(hourly_wage)
      new do |price|
        price.hourly_wage = hourly_wage
      end
    end

    # チューターの時給からレッスン料金を計算する式
    def lesson_fee_from_hourly_wage(hourly_wage)
      ((hourly_wage * Rational(3, 4) / SystemSettings.tutor_share_of_lesson_fee).to_f / base).ceil * base
    end

    # 50円単位で切り上げる
    def ceil(amount)
      (amount.to_f / base).ceil * base
    end

    private

      def base
        50
      end
  end

  validates_presence_of :hourly_wage

  before_save :init_lesson_fee_table

  after_save do
    if tutor
      TutorPriceHistory.create!(tutor:tutor, hourly_wage:hourly_wage)
    end
  end

  def init_with_hourly_wage(hourly_wage)
    self.hourly_wage = hourly_wage
    init_lesson_fee_table
    self
  end

  # 生徒を考慮しないレッスン料金を時給から
  def base_lesson_fee
    lesson_fee_0
  end

  def lesson_unit_fee(student)
    grade_premium = student.grade_premium
    case grade_premium
    when 0 then lesson_fee_0
    when 50 then lesson_fee_50
    when 100 then lesson_fee_100
    when 200 then lesson_fee_200
    else
      logger.error "TutorPrice: invalid grade_premium: #{grade_premium}"
      lesson_fee_0
    end
  end

  def lesson_unit_fee_for_grade(grade)
    case grade.premium
    when 0 then lesson_fee_0
    when 50 then lesson_fee_50
    when 100 then lesson_fee_100
    when 200 then lesson_fee_200
    else
      logger.error "TutorPrice: invalid grade_premium: #{grade.premium}"
      lesson_fee_0
    end
  end


  def lesson_extension_fee(student)
    lesson_unit_fee(student) * Lesson.extension_duration / Lesson.duration_per_unit
  end

  def reset_lesson_fee_table
    init_lesson_fee_table
    logger.info "Tutor #{tutor.id}'s lesson fees were reset"
    logger.info attributes
    self.save
  end

  # 現在のチューターの状態（仮登録、本登録、スペシャルチューター）に
  # 応じた初期状態にリセットする。
  def reset!
    # チューターの状態変更後に呼ばれるので、古い状態のチューターを
    # 参照しないように、データをリロードする。
    reload
    if tutor
      init_with_hourly_wage(default_hourly_wage_for_tutor)
      logger.debug attributes
      save!
    end
  end

  def default_hourly_wage_for_tutor
    if tutor.beginner?
      TutorPrice.beginner_tutor_default_hourly_wage
    elsif tutor.graduated?
      TutorPrice.graduated_regular_tutor_default_hourly_wage
    else
      TutorPrice.regular_tutor_default_hourly_wage
    end
  end

  def upgrade!(n=1)
    increment!(:hourly_wage, 50 * n)
  end

  # チューターの料金表を作成する。
  def init_lesson_fee_table
    if tutor.present?
      self.lesson_fee_0 = calculate_lesson_unit_fee(tutor.beginner?, tutor.graduated?, 0)
      self.lesson_fee_50 = calculate_lesson_unit_fee(tutor.beginner?, tutor.graduated?, 50)
      self.lesson_fee_100 = calculate_lesson_unit_fee(tutor.beginner?, tutor.graduated?, 100)
      self.lesson_fee_200 = calculate_lesson_unit_fee(tutor.beginner?, tutor.graduated?, 200)
      logger.debug attributes
    else
      self.lesson_fee_0 = calculate_lesson_unit_fee(true, false, 0)
      self.lesson_fee_50 = calculate_lesson_unit_fee(true, false, 50)
      self.lesson_fee_100 = calculate_lesson_unit_fee(true, false, 100)
      self.lesson_fee_200 = calculate_lesson_unit_fee(true, false, 200)
    end
  end

  private

    def calculate_lesson_unit_fee(beginner, graduated, grade_premium)
      Rails.logger.debug("beginner: #{beginner}, graduated: #{graduated}, grade_premium: #{grade_premium}")
      if beginner
        if graduated
          TutorPrice.graduated_beginner_tutor_lesson_unit_fee(grade_premium)
        else
          TutorPrice.beginner_tutor_lesson_unit_fee(grade_premium)
        end
      else
        TutorPrice.lesson_fee_from_hourly_wage(hourly_wage + grade_premium)
      end
    end

    def wage_for_minutes(minutes)
      hourly_wage * minutes / 60
    end
end

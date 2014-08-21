# coding:utf-8
module LessonMoneyMethods

  def self.included(base)
    base.has_one :lesson_tutor_wage, :foreign_key => :lesson_id, :dependent => :destroy
    base.scope :accounting_incomplete, base.where(accounting_status: 'incomplete')
  end

  ###############################################################
  # 受講者に課金する料金
  ###############################################################

  # 受講者のこのレッスンの料金
  # 延長や割引を含まない、ベースとなる金額。
  # レッスン料金は同じレッスンでも受講者ごとに異なる。
  def fee(student)
    s = student(student)
    s && s.base_lesson_fee
  end

  # このレッスンの延長料金
  # 実際に延長したかどうかにかかわらず、延長した場合にかかる追加金額を返す
  def extension_fee(student)
    s = student(student)
    s && s.extension_fee_amount
  end

  # 割引、延長料金等を合計した、生徒が支払う金額
  def total_fee(student)
    s = student(student)
    s && s.lesson_fee
  end

  ###############################################################
  # チューターへの賃金
  ###############################################################

  def tutor_total_wage
    tutor_base_wage + tutor_extension_wage + group_lesson_premium
  end

  # このレッスンのベースとなる報酬
  # １単位あたりのレッスン報酬 * 単位数
  def tutor_base_wage
    units * tutor_wage_per_unit
  end

  # このレッスンでチューターが受取る延長分の報酬
  def tutor_extension_wage
    @tutor_extension_wage ||= extended? ? tutor_extension_wage_amount : 0
  end

  # 延長した場合のチューターへの追加報酬額
  def tutor_extension_wage_amount
    @extension_tutor_amount ||= tutor_hourly_wage * Lesson.extension_duration / 60
  end

  # このレッスンにおけるチューターの１単位あたりの賃金
  def tutor_wage_per_unit
    tutor_hourly_wage * Lesson.duration_per_unit / 60
  end

  # このレッスンにおけるチューターの時給を返す
  # チューターのベースの時給＋受講者の学年によるプラスアルファ
  # 時給は受講者の学年、チューターの時給、チューターが仮登録かどうかで変化する
  # 受講者の学年に依存する。
  # 複数の生徒がいる場合は各生徒に対する平均となる
  def tutor_hourly_wage
    if tutor_base_hourly_wage.blank?
      tutor.hourly_wage
    else
      if students.empty?
        tutor_base_hourly_wage
      elsif students.count == 1
        tutor_hourly_wage_for_student(students.first)
      else
        hourly_wage_sum = students.inject(0){|sum, student| sum + tutor_hourly_wage_for_student(student)}
        hourly_wage_sum / students.count
      end
    end
  end

  ###############################################################
  # BSの取り分
  ###############################################################
  def has_bs_share?
    tutor.regular?
  end

  ###############################################################
  # その他
  ###############################################################

  # このレッスンの支払月（をあらわす日付データ）を返す
  def payment_month
    if settlement_year && settlement_month
      Date.new(settlement_year, settlement_month)
    end
  end

  # チューターに報酬を支払う月を返す。
  # これはレッスンが開催される月と同じ（前月21日から当月20日を範囲とする）
  def tutor_wage_month
    DateUtils.aid_month_of_day(date)
  end

  # 同時レッスンの場合の授業料割引額
  def group_lesson_discount(student)
    group_lesson? ? group_lesson_discount_amount(student) : 0
  end

  def group_lesson_discount_amount(student)
    s = student(student)
    s && s.group_lesson_discount_amount
  end

  # 同時レッスンの場合の給料の割増学
  def group_lesson_premium
    group_lesson? ? group_lesson_premium_amount : 0
  end

  def group_lesson_premium_amount
    (tutor_base_wage + tutor_extension_wage) * RateSettings.group_lesson_premium_rate
  end

  def sales_amount
    if established?
      students.inject(0){|sum, student| sum + total_fee(student)}
    else
      0
    end
  end

  # このレッスンに関する仕訳を作成する
  # 処理はLessonAccountingに委譲している。
  def journalize!
    accounting = LessonAccounting.new self
    accounting.journalize!
    accounting.lesson
  end

  # このレッスンに関する仕訳を削除する
  def clear_journal_entries
    accounting = LessonAccounting.new self
    accounting.clear_journal_entries
  end

  def journalized?
    journalized_at.present?
  end

  # 受講者への課金処理を扱うオブジェクトのリストを返す
  def lesson_charges
    LessonCharge.joins(:lesson_student).where(lesson_students: {lesson_id: id})
  end

  def refund
    refund! if journalized?
    true
  rescue => e
    logger.error e
    logger.lesson_log('REFUND_FAILED', log_attributes)
    false
  end

  def refund!
    if journalized?
      reverse_journal_entries!
      logger.charge_log('REFUNDED', attributes)
    end
  end

  private

    def reverse_journal_entries!
      transaction do
        journal_entries.each do |entry|
          entry.create_reversal_entry!
        end
      end
    end

    def tutor_hourly_wage_for_student(student)
      if tutor.beginner?
        tutor_base_hourly_wage
      else
        tutor_base_hourly_wage + student.grade_premium
      end
    end
end

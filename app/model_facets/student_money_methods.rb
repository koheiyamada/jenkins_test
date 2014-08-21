# coding:utf-8
module StudentMoneyMethods

  def grade_premium
    student_info.grade_premium
  end

  def max_charge
    settings.max_charge
  end

  def can_pay?(amount, month=Time.now)
    max_charge >= amount + lesson_charge_of_month(month)
  end

  def lesson_charge_of_month(month)
    monthly_stats_for(month.year, month.month).lesson_charge
  end

  # このレッスンの延長料金の金額によって延長料金の限度額を超えなければtrue
  def can_pay_lesson_extension_fee?(lesson)
    fee = lesson.extension_fee(self)
    month = lesson.payment_month
    can_pay? fee, month
  end

  def update_monthly_journal_entries!(year, month)
    charge_service = StudentChargeService.new(self)
    if charge_service.charge_for_month(year, month)

    else

    end
  end

  def afford_to_take_lesson_from?(tutor, date, units=1)
    month = Account::JournalEntry.settlement_month_of_day(date)
    remaining_amount = remaining_budget_of_month(month.year, month.month)
    remaining_amount >= tutor.lesson_fee_for_student(self) * units
  end

  def remaining_budget_of_month(year, month)
    settings.max_charge - calculate_total_lesson_fee_for_month(year, month)
  end

  # 指定した月のレッスン料金を計算して返す。未確定分も含む。
  def calculate_total_lesson_fee_for_month(year, month)
    active_lessons.of_settlement_month(year, month).inject(0){|sum, lesson| sum + lesson.fee(self)}
  end

  def monthly_usage(year, month)
    monthly_stats_for(year, month)
  end

  def on_charge_limit_reached(lesson)
    Mailer.send_mail(:charge_limit_reached, self, lesson)
  rescue => e
    logger.error e
  end

  def lesson_fees
    journal_entries.where(type: [Account::OptionalLessonFee.name, Account::BasicLessonFee.name])
  end
end
# coding:utf-8

class StudentChargeService
  class << self
    # ID管理費の対象となる受講者を返す。
    # アクティブかつ指定した月の１ヶ月以上前に入会した受講者が該当者となる。
    def students_of_id_management_fee(year, month)
        Student.only_active.only_premium.where('created_at < ?', id_management_fee_threshold(year, month))
    end

    # year, monthの月にID管理費を支払うアカウントを判別する登録日時の境界となる日時を返す
    # これが返す日時以前に登録されたアカウントがID管理費の対象となる。
    def id_management_fee_threshold(year, month)
      1.month.ago(Time.new(year, month)).change(day: SystemSettings.cutoff_date).end_of_day
    end
  end

  def initialize(student)
    @student = student
  end

  def charge_for_month(year, month)
    if should_charge_id_management_fee?(year, month)
      charge_id_management_fee(year, month)
    end
    # 本部紹介割引
    if @student.referenced_by_hq_user?
      entry = update_hq_user_reference_discount(year, month)
      if entry && entry.errors.any?
        Rails.logger.error "Failed to create HqUserReferenceDiscount for #{@student.id}. Reason: #{entry.errors.full_messages}"
      end
    end
    self
  end

  def charge_id_management_fee(year, month)
    if should_charge_id_management_fee?(year, month)
      if @student.premium?
        fee = @student.id_management_fees.create(year:year, month:month, amount_of_payment:ChargeSettings.student_id_management_fee)
        if fee.errors.any?
          Rails.logger.error "Failed to charge StudentIdManagementFee to #{@student.id} for #{year}/#{month}, " + fee.errors.full_messages.join(', ')
        end
      end
    end
  end

  def should_charge_id_management_fee?(year, month)
    if @student.id_management_fees.of_month(year, month).present?
      false
    else
      more_than_one_month_since_enrolled?(year, month)
    end
  end

  def more_than_one_month_since_enrolled?(year, month)
    enrolled_at = @student.enrolled_at || @student.created_at
    period = Account::JournalEntry.period_of_settlement_month(year, month)
    enrolled_at < period.first.to_time
  end

  def update_hq_user_reference_discount(year, month)
    remove_hq_user_reference_discount(year, month)
    create_hq_user_reference_discount(year, month)
  end

  private
    def create_hq_user_reference_discount(year, month)
      @student.hq_user_reference_discounts.create do |entry|
        entry.year = year
        entry.month = month
        entry.amount_of_payment = - calculate_hq_user_reference_discount(year, month)
      end
    end

    def remove_hq_user_reference_discount(year, month)
      @student.hq_user_reference_discounts.of_month(year, month).destroy_all
    end

    # ひと月分のレッスン料金の割引金額を計算して返す
    def calculate_hq_user_reference_discount(year, month)
      fee = calculate_lesson_fees_of_month(year, month)
      fee * SystemSettings.hq_user_reference_discount_rate
    end

    # 受講者のひと月分のレッスン料金を集計して返す
    def calculate_lesson_fees_of_month(year, month)
      @student.lesson_fees.of_month(year, month).sum(:amount_of_payment)
    end
end
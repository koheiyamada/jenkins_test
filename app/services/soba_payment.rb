class SobaPayment
  def initialize(soba)
    @soba = soba
  end

  def journalize_for_month(year, month)
    unless journalized_for_month?(year, month)
      active_user_count = calculate_active_user_count(year, month)
      amount = ChargeSettings.soba_id_management_fee * active_user_count
      fee = @soba.soba_id_management_fees.create(amount_of_money_received: amount, year: year, month: month)
      if fee.errors.any?
        Rails.logger.error fee.errors.full_messages.join(', ')
      end
    end
  end

private

  def journalized_for_month?(year, month)
    @soba.journal_entries.of_month(year, month).present?
  end

  def calculate_active_user_count(year, month)
    StudentChargeService.students_of_id_management_fee(year, month).count
  end

end
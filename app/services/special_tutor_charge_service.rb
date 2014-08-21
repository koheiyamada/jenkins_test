# coding:utf-8

class SpecialTutorChargeService
  def initialize(tutor)
    @tutor = tutor
  end

  def charge_for_month(year, month)
    if @tutor.special_tutor_fees.of_month(year, month).blank?
      fee = @tutor.special_tutor_fees.create(year:year, month:month, amount_of_payment: ChargeSettings.special_tutor_fee)
      if fee.errors.any?
        Rails.logger.error "Failed to charge StudentIdManagementFee to #{id} for #{year}/#{month}, " + fee.errors.full_messages.join(', ')
      end
    end
    self
  end
end
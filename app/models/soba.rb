class Soba < Organization
  #include Ledgerable

  class << self
    def instance
      first
    end
  end

  has_many :soba_id_management_fees, class_name: Account::SobaIdManagementFee.name, as: :owner

  def update_monthly_journal_entries!(year, month)
    payment_service = SobaPayment.new(self)
    if payment_service.journalize_for_month(year, month)

    else

    end
  end
end

class MonthlyChargingUser < ActiveRecord::Base
  class << self
    def clear(year, month)
      where(year: year, month: month).delete_all
    end

    def of_month(year, month)
      where(year: year, month: month)
    end

    def calculate(year, month)
      SobaChargeService.delay.enumerate_accounts_for_license_fee(year, month)
    end
  end

  belongs_to :user
  attr_accessible :full_name, :month, :user_id, :user_name, :user_type, :year
end

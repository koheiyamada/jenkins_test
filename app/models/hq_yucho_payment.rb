class HqYuchoPayment < ActiveRecord::Base
  class << self
    def of_month(year, month)
      includes(:monthly_statement).where(monthly_statements: {year: year, month: month})
    end
  end

  belongs_to :yucho_account
  belongs_to :monthly_statement
  attr_accessible :amount

  validates_uniqueness_of :yucho_account_id, :scope => :monthly_statement_id
end

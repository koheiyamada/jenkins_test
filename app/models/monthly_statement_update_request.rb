class MonthlyStatementUpdateRequest < ActiveRecord::Base
  class << self
    def execute_all
      scoped.each do |obj|
        obj.execute
      end
      delete_all
      logger.info 'RUN: MonthlyStatementUpdateRequest.execute_all'
    end
  end

  belongs_to :owner, polymorphic: true
  attr_accessible :owner, :year, :month

  validates_presence_of :owner_id, :owner_type, :year, :month
  validates_uniqueness_of :owner_id, scope: [:owner_type, :year, :month]

  def execute
    ms = owner.update_monthly_statement_for(year, month)
    if ms.errors.present?
      logger.error("Failed to update the monthly statement of owner_id: #{owner_id}, owner_type: #{owner_type}, year: #{year}, month: #{month}")
    end
    ms.errors.empty?
  end
end

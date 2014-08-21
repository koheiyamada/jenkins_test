class CreditCard < ActiveRecord::Base
  def self.columns
    @columns ||= []
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end

  column :number, :string
  column :expire, :date
  column :security_code, :string

  attr_accessible :number, :expire, :security_code

  validate :validate_number
  validate :validate_expire
  validates :security_code,
    presence: true,
    length: { in: 3..4 },
    numericality: { only_integer: true }

  private
  def validate_number
    if number.blank?
      errors.add :number, :empty
    elsif !(ActiveMerchant::Billing::CreditCard.brand?(number) &&
            ActiveMerchant::Billing::CreditCard.valid_number?(number))
      errors.add :number, :invalid
    end
  end

  def validate_expire
    if expire.blank?
      errors.add :expire, :empty
    elsif expire < 2000.years.ago.to_date
      errors.add :expire, :expired
    end
  end
end

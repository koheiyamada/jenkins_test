class MonthlyStatementItem < ActiveRecord::Base
  class << self
    def of_type(account_item_class)
      where(account_item:account_item_class.name)
    end
  end

  belongs_to :monthly_statement
  attr_accessible :year, :month, :account_item, :amount_of_payment, :amount_of_money_received

  validates_presence_of :year, :month, :account_item

  def payment
    amount_of_payment - amount_of_money_received
  end

  def receipt
    amount_of_money_received - amount_of_payment
  end
end

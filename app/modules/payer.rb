module Payer
  def self.included(base)
    base.has_one :payment_method, foreign_key: :user_id, dependent: :destroy
    base.attr_accessible :payment_method
  end
end
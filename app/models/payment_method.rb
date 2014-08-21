class PaymentMethod < ActiveRecord::Base
  belongs_to :user
  attr_accessible :type

  validates_presence_of :user_id, :type
end

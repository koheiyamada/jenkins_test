class TutorPriceHistory < ActiveRecord::Base
  belongs_to :tutor
  attr_accessible :hourly_wage, :tutor

  validates_presence_of :hourly_wage, :tutor
end

class CustomOperatingSystem < ActiveRecord::Base
  belongs_to :user_operating_system
  attr_accessible :name

  validates_presence_of :name
end

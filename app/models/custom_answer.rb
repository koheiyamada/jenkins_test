class CustomAnswer < ActiveRecord::Base
  belongs_to :answer
  attr_accessible :value
end

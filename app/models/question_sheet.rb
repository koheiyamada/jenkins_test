class QuestionSheet < ActiveRecord::Base
  belongs_to :exam
  attr_accessible :image
end

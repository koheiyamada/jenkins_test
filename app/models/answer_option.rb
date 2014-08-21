class AnswerOption < ActiveRecord::Base
  belongs_to :question
  attr_accessible :code
end

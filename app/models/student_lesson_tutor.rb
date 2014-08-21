class StudentLessonTutor < ActiveRecord::Base
  belongs_to :student
  belongs_to :tutor
  # attr_accessible :title, :body
end

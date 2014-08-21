class BasicLessonPossibleStudent < ActiveRecord::Base
  belongs_to :basic_lesson_info
  belongs_to :student
  # attr_accessible :title, :body
end

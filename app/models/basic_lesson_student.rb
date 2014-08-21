class BasicLessonStudent < ActiveRecord::Base
  belongs_to :basic_lesson_info
  belongs_to :student

  attr_accessible :student

  validate :student_is_acceptable, :on => :create

  private

    def student_is_acceptable
      unless basic_lesson_info.student_acceptable? student
        errors.add :student, :not_acceptable
      end
    end
end

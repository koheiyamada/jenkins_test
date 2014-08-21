class LessonExtensionRequest < ActiveRecord::Base
  belongs_to :lesson_student

  validates_presence_of :lesson_student_id
  validate :student_can_request_extension
  validate :tutor_can_undertake_extension

  def student
    lesson_student.student
  end

  def lesson
    lesson_student.lesson
  end

  private

    def student_can_request_extension
      unless student.can_pay_lesson_extension_fee?(lesson)
        errors.add(:student, :over_charge_limit)
      end
      if student.lessons.where(start_time: lesson.end_time .. 45.minutes.since(lesson.end_time)).any?
        errors.add(:student, :has_another_lesson)
      end
    end

    def tutor_can_undertake_extension
      next_lesson = lesson.tutor.next_lesson_of(lesson)
      if next_lesson && next_lesson.conflict?(lesson.start_time..lesson.end_time_after_extended, Lesson.min_interval)
        errors.add :lesson, :tutor_has_another_lesson
      end
    end
end

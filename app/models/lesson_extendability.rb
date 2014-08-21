class LessonExtendability < ActiveRecord::Base
  belongs_to :lesson
  attr_accessible :extendable, :reason

  validates_presence_of :lesson_id
  validate :students_can_request_extension
  validate :tutor_can_undertake_extension
  validate :lesson_is_open

  before_create do
    self.extendable = true
    self.reason = nil
  end

  def reasons
    if errors.any?
      errors.full_messages
    else
      nil
    end
  end

  def as_json(options = nil)
    super(options).merge(reasons:reasons)
  end

  private

    def lesson_is_open
      unless lesson.open?
        errors.add :lesson, :not_open
      end
    end

    def students_can_request_extension
      unless lesson.students.all?{|student| student.can_pay_lesson_extension_fee?(lesson)}
        errors.add(:lesson, :students_over_charge_limits)
      end
    end

    def tutor_can_undertake_extension
      next_lesson = lesson.tutor.next_lesson_of(lesson)
      if next_lesson && next_lesson.conflict?(lesson.start_time..lesson.end_time_after_extended, Lesson.min_interval)
        errors.add :lesson, :tutor_has_another_lesson
      end
    end
end

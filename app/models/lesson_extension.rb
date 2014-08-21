class LessonExtension < ActiveRecord::Base
  belongs_to :lesson

  validates_presence_of :lesson_id
  validate :lesson_is_open, :on => :create
  validate :lesson_has_attending_students, :on => :create
  validate :all_attending_student_applied, :on => :create

  before_create :extend_lesson

  private

    def extend_lesson
      lesson.update_attribute(:extended, true)
    end

    def lesson_is_open
      unless lesson.open?
        errors.add :lesson, :lesson_is_not_open
      end
    end

    def lesson_has_attending_students
      if lesson.attended_students.empty?
        errors.add :lesson, :not_have_attended_students
      end
    end

    def all_attending_student_applied
      unless lesson.lesson_students.attended.all?{|lesson_student| lesson_student.lesson_extension_request.present?}
        errors.add :lesson, :not_all_students_applied_extension
      end
    end
end

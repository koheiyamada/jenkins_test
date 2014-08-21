# coding:utf-8

class LessonCancellation < ActiveRecord::Base
  belongs_to :lesson_student
  attr_accessor :validation
  attr_accessible :validation, :reason

  validates_presence_of :lesson_student_id, :reason

  with_options if: :validation? do |v|
    v.validate :student_is_active
    v.validate :lesson_is_active
    v.validate :lesson_is_cancellable_state
    #v.validate :time_to_accept_cancellation
    v.validate :student_not_cancelled_too_many_times
  end

  after_create :send_mail

  after_create do
    lesson_student.on_cancelled
    true
  end

  def lesson
    lesson_student.lesson
  end

  def student
    lesson_student.student
  end

  def validation?
    @validation.nil? ? true : @validation
  end

  private

    #
    # 検証
    #

    def student_is_active
      unless lesson_student.active?
        errors.add :lesson_student_id, :not_active
      end
    end

    def lesson_is_active
      unless lesson.active?
        errors.add :lesson, :not_active
      end
    end

    def lesson_is_cancellable_state
      unless lesson.new? || lesson.accepted?
        errors.add :lesson, :not_cancellable_state
      end
    end

    def time_to_accept_cancellation
      unless lesson.new? || lesson.accepted?
        unless lesson.cancellation_period_for? student
          errors.add :lesson, :not_time_to_accept_cancellation
        end
      end
    end

    def student_not_cancelled_too_many_times
      unless student.can_cancel_more? lesson
        #errors.add :student, :cancelled_too_many_times
      end
    end

    #
    #
    #

    def send_mail
      Mailer.send_mail :student_lesson_cancelled, self
    end
end

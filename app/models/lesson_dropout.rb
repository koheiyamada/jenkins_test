class LessonDropout < ActiveRecord::Base
  belongs_to :lesson_student

  validates_presence_of :lesson_student_id

  validate :lesson_is_open,        on: :create
  validate :lesson_room_door_open, on: :create
  validate :current_time_is_before_time_door_close, on: :create

  after_create do
    lesson_student.on_dropped_out(self).valid?
  end

  def lesson
    lesson_student.lesson
  end

  private

    def lesson_is_open
      unless lesson.open?
        errors.add :lesson, :not_open
      end
    end

    def lesson_room_door_open
      if lesson.dropout_closed?
        errors.add :lesson, :dropout_closed
      end
    end

    def current_time_is_before_time_door_close
      if lesson.dropout_closing_time.present?
        if Time.current > lesson.dropout_closing_time
          errors.add :lesson, :after_time_door_close
        end
      end
    end
end

class LessonStatusMonitor
  extend Loggable

  def self.after_update(lesson)
    if lesson.status_changed?
      logger.lesson_log(
        'STATUS_CHANGED',
        id:         lesson.id,
        start_time: lesson.start_time,
        end_time:   lesson.end_time,
        from:       lesson.status_was,
        to:         lesson.status)

      case lesson.status
      when Lesson::Status::RESCHEDULING
        # チューターと生徒にメールを出す
        Mailer.send_mail(:lesson_schedule_change_requested, lesson)
      when Lesson::Status::CANCELLED
        lesson.send :on_cancelled
      when Lesson::Status::DONE
        lesson.send :on_done
      when Lesson::Status::ACCEPTED
        lesson.send :on_accepted
      when Lesson::Status::NOT_STARTED
        lesson.send :on_skipped
      else
        # do nothing
      end
    end
  end

end

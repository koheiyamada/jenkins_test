class LessonCancellationCount < ScheduledJob

  def self.perform
    Lesson.calculate_cancellation_of_day(Date.yesterday)
  end

end
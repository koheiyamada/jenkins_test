class SweepIgnoredLessonRequests < ScheduledJob

  def self.perform
    Lesson.sweep_ignored_requests
  end

end
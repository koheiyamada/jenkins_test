class TutorLessonSkipClear < ScheduledJob

  def self.perform
    Tutor.clear_lesson_skip_counts
  end

end
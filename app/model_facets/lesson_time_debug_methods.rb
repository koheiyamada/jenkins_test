module LessonTimeDebugMethods

  def time_to_check_lesson_extension
    31.minutes.since(started_at || start_time)
  end

end
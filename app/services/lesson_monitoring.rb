class LessonMonitoring
  def initialize(lesson)
    @lesson = lesson
  end

  def can_monitor_now?
    @lesson.open? || (@lesson.current? && @lesson.fixed?)
  end
end
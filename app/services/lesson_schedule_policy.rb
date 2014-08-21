class LessonSchedulePolicy
  def initialize(lesson)
    @lesson = lesson
  end

  def start_time_change_limit
    if @lesson.original_start_time
      @start_time_change_limit = @lesson.original_start_time.next_month.change(day:SystemSettings.cutoff_date).end_of_day
    end
  end
end
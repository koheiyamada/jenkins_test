module BasicLessonMember
  def have_conflicting_basic_lesson_schedule?(basic_lesson_weekday_schedule)
    if basic_lesson_weekday_schedule.new_record?
      basic_lesson_weekly_schedules
      .conflict_with(basic_lesson_weekday_schedule, 15)
      .any?
    else
      basic_lesson_weekly_schedules
      .except_for(basic_lesson_weekday_schedule.id)
      .conflict_with(basic_lesson_weekday_schedule, 15)
      .any?
    end
  end

  def conflicting_basic_lesson_schedules(basic_lesson_weekday_schedule)
    if basic_lesson_weekday_schedule.new_record?
      basic_lesson_weekly_schedules
      .conflict_with(basic_lesson_weekday_schedule, Lesson.min_interval)
    else
      basic_lesson_weekly_schedules
      .except_for(basic_lesson_weekday_schedule.id)
      .conflict_with(basic_lesson_weekday_schedule, Lesson.min_interval)
    end
  end
end
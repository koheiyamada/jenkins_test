module BasicLessonsHelper
  def basic_lesson_schedule_for_tutor(schedule)
    I18n.t('basic_lesson_info.time_range',
      wday: I18n.t('date.abbr_day_names')[schedule.wday],
      from: I18n.l(schedule.start_time, format: :only_time),
      to:   I18n.l(schedule.end_time, format: :only_time))
  end

  def basic_lesson_schedule_for_student(schedule)
    I18n.t('basic_lesson_info.time_range_and_tutor',
      wday:  I18n.t('date.abbr_day_names')[schedule.wday],
      from:  I18n.l(schedule.start_time, format: :only_time),
      to:    I18n.l(schedule.end_time, format: :only_time),
      tutor: schedule.basic_lesson_info.tutor.nickname)
  end
end

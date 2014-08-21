module LessonRoom
  private

    def lesson_to_json(lesson)
      hash = lesson.as_json(methods: [:time_lesson_end,
                                      :time_to_check_lesson_extension,
                                      :time_room_close,
                                      :attended_member_ids,
                                      :dropout_closing_time])
      hash.merge(time_door_open: lesson.entry_start_time_for(current_user),
                 time_door_close: lesson.entry_end_time_for(current_user))
    end
end

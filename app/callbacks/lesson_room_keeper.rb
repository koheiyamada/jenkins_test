class LessonRoomKeeper
  extend Loggable

  def self.after_update(lesson)
    logger.debug "LessonRoomKeeper.after_update for Lesson #{lesson.id}"
    if lesson.door_closed_changed?
      if lesson.door_closed?
        logger.lesson_log('DOOR_CLOSED', lesson.attributes)
        lesson.on_door_closed
      end
    end
    if lesson.started_at_changed?
      logger.lesson_log('STARTED', lesson.attributes)
    end
    if lesson.ended_at_changed?
      logger.lesson_log('ENDED', lesson.attributes)
    end
    if lesson.extended_changed? && lesson.extended?
      logger.lesson_log('EXTENDED', lesson.attributes)
    end
  end
end

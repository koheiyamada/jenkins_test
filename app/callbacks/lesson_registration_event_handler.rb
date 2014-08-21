class LessonRegistrationEventHandler
  def after_update(lesson)
    if become_fixed? lesson
      lesson.lesson_students.each{|s| s.on_lesson_fixed}
    end
  end

  private

    def become_fixed?(lesson)
      lesson.status_was == Lesson::Status::BUILD && lesson.status == Lesson::Status::NEW
    end
end
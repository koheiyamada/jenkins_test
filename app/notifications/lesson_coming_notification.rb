class LessonComingNotification < Struct.new(:lesson_id)
  def perform
    lesson = Lesson.find_by_id(lesson_id)
    if lesson
      Mailer.send_mail(:lesson_coming_notification, lesson)
    end
  end
end
class Tu::LessonReportsController < LessonReportsController
  tutor_only

  def unwritten
    @lessons = current_user.lessons.unreported
  end

end

class Tu::BasicLessonInfos::StudentsController < StudentsController
  tutor_only

  private

    def subject
      @basic_lesson_info ||= BasicLessonInfo.find(params[:basic_lesson_info_id])
    end
end

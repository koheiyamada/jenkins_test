class Hq::BasicLessonInfos::StudentsController < BasicLessonInfoStudentsController
  hq_user_only

  private

    def redirect_path
      hq_basic_lesson_info_path(@basic_lesson_info)
    end
end

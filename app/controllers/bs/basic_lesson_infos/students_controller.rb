class Bs::BasicLessonInfos::StudentsController < BasicLessonInfoStudentsController
  bs_user_only

  def index
    redirect_to redirect_path
  end

  private

    def redirect_path
      bs_basic_lesson_info_path(@basic_lesson_info)
    end
end

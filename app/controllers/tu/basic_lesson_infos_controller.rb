class Tu::BasicLessonInfosController < BasicLessonInfosController
  tutor_only

  def accept
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.accept_and_supply_lessons
    redirect_to action:'show'
  end

  def reject
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.reject
    redirect_to action:'show'
  end
end

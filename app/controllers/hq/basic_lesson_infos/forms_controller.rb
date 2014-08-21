class Hq::BasicLessonInfos::FormsController < BasicLessonInfoFormsController
  hq_user_only

  private

  def finish_wizard_path
    pending_hq_basic_lesson_infos_path
  end

  def redirect_path_on_cancellation
    new_hq_basic_lesson_info_path
  end
end

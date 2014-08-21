class Bs::Students::BasicLessonInfos::LessonsController < Bs::BasicLessonInfos::LessonsController
  prepend_before_filter :prepare_student

  private

  def prepare_basic_lesson_info
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:basic_lesson_info_id])
  end
end

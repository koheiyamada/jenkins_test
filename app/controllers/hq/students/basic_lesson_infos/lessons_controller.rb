class Hq::Students::BasicLessonInfos::LessonsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :lesson
  layout 'with_sidebar'
  before_filter :prepare_student
  before_filter :prepare_basic_lesson_info

  def index
    @lessons = @basic_lesson_info.lessons.order('start_time DESC').page(params[:page])
  end

  def show
    @lesson = @basic_lesson_info.lessons.find(params[:id])
  end

  private

    def prepare_basic_lesson_info
      @basic_lesson_info = @student.basic_lesson_infos.find(params[:basic_lesson_info_id])
    end
end

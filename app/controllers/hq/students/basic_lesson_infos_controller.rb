class Hq::Students::BasicLessonInfosController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :lesson
  layout 'with_sidebar'
  before_filter :prepare_student

  def index
    @basic_lesson_infos = @student.fixed_basic_lesson_infos
  end

  def new
    current_user.clear_incomplete_basic_lesson_infos
    @basic_lesson_info = BasicLessonInfo.new
    @basic_lesson_info.creator = current_user
    @basic_lesson_info.students << @student
    if @basic_lesson_info.save
      redirect_to hq_basic_lesson_info_forms_path(@basic_lesson_info)
    else
      render action:"new"
    end
  end

  def show
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:id])
  end

  # 授業データを１ヶ月分追加する
  def extend
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.extend_months
    redirect_to action:"show"
  end

  def turn_off_auto_extension
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.turn_off_auto_extension
    redirect_to action:"show"
  end

  def turn_on_auto_extension
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.turn_on_auto_extension
    redirect_to action:"show"
  end

  def destroy
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.destroy
    redirect_to action:"index"
  end
end

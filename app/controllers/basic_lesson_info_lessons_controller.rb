class BasicLessonInfoLessonsController < ApplicationController
  before_filter :prepare_basic_lesson_info
  layout 'with_sidebar'

  def index
    @lessons = @basic_lesson_info.lessons.order('start_time DESC').page(params[:page])
  end

  def supply
    @basic_lesson_info.supply_lessons
    redirect_to({action: :index}, notice:t('messages.supplied_basic_lessons'))
  end

  def show
    @lesson = @basic_lesson_info.lessons.find(params[:id])
  end

  def cancel
    @lesson = @basic_lesson_info.lessons.find_by_id(params[:id])
    if @lesson.cancel(current_user)
      redirect_to({action: :index}, notice: I18n.t('messages.lesson_canceled'))
    else
      redirect_to({action: :index}, alert: I18n.t('lesson.message.failed_to_cancel'))
    end
  end

  def cancel_selected
    @lessons = @basic_lesson_info.lessons.going_to_be_held.where(id: params[:id])
    if @lessons.cancel_all
      redirect_to({action: :index}, notice: I18n.t('messages.lesson_canceled'))
    else
      redirect_to({action: :index}, alert: I18n.t('lesson.message.failed_to_cancel'))
    end
  end

  private

    def prepare_basic_lesson_info
      @basic_lesson_info = current_user.basic_lesson_infos.find(params[:basic_lesson_info_id])
    end
end

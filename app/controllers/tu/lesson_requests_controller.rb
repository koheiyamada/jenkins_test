class Tu::LessonRequestsController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @lessons = current_user.lesson_requests.where(status: 'new').page(params[:page])
  end

  def show
    @lesson = current_user.lesson_requests.find_by_id(params[:id])
    if @lesson.nil?
      redirect_to action: :index
    end
  end

  def accept
    @lesson = current_user.lessons.find(params[:id])
    @lesson.accept
    if @lesson.errors.empty?
      #free_lesson_taken を増やす
      #Student.new.free_lesson_taken_add(@lesson.creator_id)
      redirect_to({action:'index'}, :notice => t('messages.accepted_lesson'))
    else
      render :show
    end
  end

  def reject
    @lesson = current_user.lesson_requests.find(params[:id])
    if @lesson.reject
      redirect_to({action:'index'}, :notice => t("messages.rejected_lesson"))
    else
      redirect_to({action:'index'}, :notice => t('messages.failed_to_accept_lesson'))
    end
  end
end
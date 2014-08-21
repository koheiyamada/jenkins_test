class BasicLessonInfosController < ApplicationController
  layout 'with_sidebar'

  def index
    @basic_lesson_infos = current_user.basic_lesson_infos.only_current.for_list.page(params[:page])
  end

  def pending
    @basic_lesson_infos = current_user.basic_lesson_infos.pending.for_list.order('basic_lesson_infos.created_at DESC').page(params[:page])
  end

  def rejected
    @basic_lesson_infos = current_user.basic_lesson_infos.rejected.for_list.order('basic_lesson_infos.created_at DESC').page(params[:page])
  end

  def closed
    @basic_lesson_infos = current_user.basic_lesson_infos.closed.for_list.order('basic_lesson_infos.created_at DESC').page(params[:page])
  end

  def shared
    if params[:q]
      search = BasicLessonSearch.new(params.merge(shared_lesson: true))
      @basic_lesson_infos = search.execute
    else
      @basic_lesson_infos = current_user.basic_lesson_infos.shared.only_active.for_list.order('basic_lesson_infos.created_at DESC').page(params[:page])
    end
  end

  def show
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
    fresh_when @basic_lesson_info
  end

  def close
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
    if request.post?
      @basic_lesson_info.delay.close
      render json: @basic_lesson_info
    else
      unless @basic_lesson_info.active?
        redirect_to action: :show
      end
    end
  end

  def status
    @basic_lesson_info = current_user.basic_lesson_infos.select(:status).find(params[:id])
    respond_to do |format|
      format.json do
        render json: @basic_lesson_info
      end
    end
  end

  def destroy
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.destroy
    redirect_to action:'index'
  end

  private

    def basic_lesson_class(type=nil)
      case type
      when 'friends' then FriendsBasicLessonInfo
      when 'shared' then SharedBasicLessonInfo
      else BasicLessonInfo
      end
    end

    def search_basic_lesson_infos
      options = {shared_lesson: true, active: true}
      options[:wday] = params[:wday].to_i if params[:wday].present?
      options[:hour] = params[:start_time][:hour].to_i if params[:start_time][:hour].present?
      options[:full] = params[:only_not_full] != '1' if params[:only_not_full].present?
      current_user.search_basic_lesson_infos(params[:q], options)
    end
end

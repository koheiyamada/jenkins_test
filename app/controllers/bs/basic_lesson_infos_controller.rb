# coding:utf-8

class Bs::BasicLessonInfosController < BasicLessonInfosController
  bs_user_only
  layout 'with_sidebar'

  def shared
    if params[:q]
      search = BasicLessonSearch.new(params.merge(shared_lesson: true))
      @basic_lesson_infos = search.execute
    else
      # 全同時レッスンを対象とする
      @basic_lesson_infos = BasicLessonInfo.shared.only_active.order('created_at DESC').page(params[:page])
    end
  end

  def new
    @basic_lesson_info = BasicLessonInfo.new # dummy
  end

  def create
    @basic_lesson_info = basic_lesson_class(params[:type]).new(creator:current_user)
    if @basic_lesson_info.save
      redirect_to forms_path
    else
      render action: 'new'
    end
  end

  def show
    # 自分のところと関係のない受講者の分も閲覧できる必要がある。
    @basic_lesson_info = BasicLessonInfo.find_by_id(params[:id])
    if @basic_lesson_info.nil?
      render template:'basic_lesson_infos/nonexistent_lesson'
    end
  end

  # 決定前のレッスンをキャンセルする
  def cancel
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
    if @basic_lesson_info.cancel
      redirect_to({action:'index'}, notice:t('lesson.message.request_canceled'))
    else
      redirect_to({action:'show'}, notice:t('lesson.message.failed_to_cancel'))
    end
  end

  # basic_lesson_infos/:id/supply
  def supply
    @basic_lesson_info = basic_lesson_infos.find(params[:id])
    @basic_lesson_info.supply_lessons
    redirect_to action:"show"
  end

  def lessons
    @basic_lesson_info = basic_lesson_infos.find(params[:id])
    @lessons = @basic_lesson_info.lessons.future.order("start_time").page(params[:page])
  end

  def stop
    @basic_lesson_info = basic_lesson_infos.find(params[:id])
    if request.get?
      @basic_lesson_info.final_day = Date.today
    else
      @basic_lesson_info.stop_in_month(params[:date][:year], params[:date][:month])
      if @basic_lesson_info.save
        redirect_to action:"show"
      else
        # do nothing
      end
    end
  end

  def turn_off_auto_extension
    @basic_lesson_info = basic_lesson_infos.find(params[:id], readonly: false)
    @basic_lesson_info.turn_off_auto_extension
    redirect_to action:"show"
  end

  def turn_on_auto_extension
    @basic_lesson_info = basic_lesson_infos.find(params[:id], readonly: false)
    @basic_lesson_info.turn_on_auto_extension
    redirect_to action:"show"
  end

  private

    def basic_lesson_infos
      current_user.basic_lesson_infos.only_complete
    end

    def new_basic_lesson_info
      BasicLessonInfo.new do |basic_lesson_info|
        basic_lesson_info.creator = current_user
      end
    end

    def forms_path
      bs_basic_lesson_info_forms_path(@basic_lesson_info)
    end
end

class Hq::BasicLessonInfosController < BasicLessonInfosController
  include HqUserAccessControl
  hq_user_only
  access_control :lesson
  layout 'with_sidebar'

  def new
    @basic_lesson_info = BasicLessonInfo.new # dummy
  end

  def create
    @basic_lesson_info = basic_lesson_class.new(creator:current_user)
    if @basic_lesson_info.save
      redirect_to forms_path
    else
      render action: 'new'
    end
  end

  def show
    @basic_lesson_info = current_user.basic_lesson_infos.find(params[:id])
  end

  # basic_lesson_infos/:id/supply
  def supply
    @basic_lesson_info = basic_lesson_infos.find(params[:id])
    @basic_lesson_info.supply_lessons
    redirect_to action:"show"
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
    @basic_lesson_info = basic_lesson_infos.find(params[:id])
    @basic_lesson_info.turn_off_auto_extension
    redirect_to action:"show"
  end

  def turn_on_auto_extension
    @basic_lesson_info = basic_lesson_infos.find(params[:id])
    @basic_lesson_info.turn_on_auto_extension
    redirect_to action:"show"
  end

  def cancel_request
    @basic_lesson_info = current_user.basic_lesson_infos.pending.find_by_id(params[:id])
    if @basic_lesson_info && @basic_lesson_info.cancel
      redirect_to({action:'pending'}, notice:t('lesson.message.request_canceled'))
    else
      redirect_to({action:'show'}, notice:t('lesson.message.failed_to_cancel'))
    end
  end

  private

    def basic_lesson_infos
      current_user.basic_lesson_infos.only_complete
    end

    def basic_lesson_class
      case params[:type]
      when 'friends' then FriendsBasicLessonInfo
      when 'shared' then SharedBasicLessonInfo
      else BasicLessonInfo
      end
    end

    def forms_path
      hq_basic_lesson_info_forms_path(@basic_lesson_info)
    end
end

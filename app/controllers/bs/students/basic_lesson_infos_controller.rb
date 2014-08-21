class Bs::Students::BasicLessonInfosController < Bs::BasicLessonInfosController
  prepend_before_filter :prepare_student
  before_filter :prepare_student

  def index
    @basic_lesson_infos = @student.basic_lesson_infos.only_active.page(params[:page])
  end

  def new
    current_user.clear_incomplete_basic_lesson_infos
    @basic_lesson_info = BasicLessonInfo.new
    @basic_lesson_info.creator = current_user
    @basic_lesson_info.students << @student
    if @basic_lesson_info.save
      redirect_to bs_basic_lesson_info_forms_path(@basic_lesson_info)
    else
      render :action
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

  def destroy
    @basic_lesson_info = @student.basic_lesson_infos.find(params[:id])
    @basic_lesson_info.destroy
    redirect_to action:"index"
  end

  private

    def basic_lesson_infos
      @student.basic_lesson_infos.only_complete
    end

    def new_basic_lesson_info
      BasicLessonInfo.new do |basic_lesson_info|
        basic_lesson_info.creator = current_user
        basic_lesson_info.students << @student
      end
    end

    def forms_path
      bs_basic_lesson_info_forms_path(@basic_lesson_info)
    end
end

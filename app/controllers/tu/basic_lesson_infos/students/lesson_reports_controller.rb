class Tu::BasicLessonInfos::Students::LessonReportsController < LessonReportsController
  tutor_only
  before_filter :prepare_basic_lesson_info, :prepare_student

  def index
    @lesson_reports = @student.lesson_reports.order('id DESC').page(params[:page])
  end

  def show
    @lesson_report = @student.lesson_reports.find(params[:id])
  end

  private

    def prepare_basic_lesson_info
      @basic_lesson_info = current_user.basic_lesson_infos.find(params[:basic_lesson_info_id])
    end

    def prepare_student
      @student = @basic_lesson_info.students.find(params[:student_id])
    end
end

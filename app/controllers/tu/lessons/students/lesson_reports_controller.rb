class Tu::Lessons::Students::LessonReportsController < LessonReportsController
  tutor_only
  before_filter :prepare_lesson, :prepare_student

  def index
    @lesson_reports = @student.lesson_reports.order('id DESC').page(params[:page])
  end

  def show
    @lesson_report = @student.lesson_reports.find(params[:id])
  end
end

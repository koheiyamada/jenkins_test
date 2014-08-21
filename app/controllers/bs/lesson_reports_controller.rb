class Bs::LessonReportsController < LessonReportsController
  bs_user_only

  def show
    @lesson_report = current_user.lesson_reports.find(params[:id])
  end

  private

  def search_lesson_reports_with_query
    options = {
      date: DateUtils.parse(params[:date]),
      page: params[:page],
      student_ids: current_user.students.pluck(:id)
    }
    current_user.search_lesson_reports(params[:q], options)
  end
end

class Bs::StudentLessonReportsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'

  def index
    @student = current_user.students.find(params[:student_id])
    @lesson_reports = @student.lesson_reports.order("created_at DESC")
  end
end

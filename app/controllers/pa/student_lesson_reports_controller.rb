class Pa::StudentLessonReportsController < ApplicationController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'
  before_filter :prepare_student

  def index
    @lesson_reports = @student.lesson_reports.order('created_at DESC').page(params[:page])
  end

  def show
    @lesson_report = @student.lesson_reports.find(params[:id])
  end
end

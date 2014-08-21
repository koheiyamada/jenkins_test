class LessonReportsController < ApplicationController
  layout 'with_sidebar'

  def index
    if params[:q]
      @lesson_reports = search_lesson_reports
    else
      @lesson_reports = subject.latest_lesson_reports.for_list.page(params[:page])
    end
  end

  def show
    @lesson_report = subject.lesson_reports.find(params[:id])
  end

  def prev
    @lesson_report = subject.lesson_reports.find(params[:id]).prev
    if @lesson_report
      redirect_to action:'show', id:@lesson_report
    end
  end

  def next
    @lesson_report = subject.lesson_reports.find(params[:id]).next
    if @lesson_report
      redirect_to action:'show', id:@lesson_report
    end
  end

  def edit
    @lesson_report = subject.lesson_reports.find(params[:id])
  end

  def update
    @lesson_report = subject.lesson_reports.find(params[:id])
    if @lesson_report.update_attributes(params[:lesson_report])
      redirect_to({action:'show'}, notice:t('messages.updated'))
    else
      render action:'edit'
    end
  end

  private

  def subject
    current_user
  end

  def search_lesson_reports
    if params[:id].present?
      current_user.lesson_reports.where(id:params[:id]).page(params[:page])
    else
      search_lesson_reports_with_query
    end
  end

  # Solrから検索する
  def search_lesson_reports_with_query
    date = DateUtils.parse(params[:date])
    current_user.search_lesson_reports(params[:q], date:date, page:params[:page])
  end
end

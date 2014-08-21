class St::LessonCsSheetsController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'
  before_filter :prepare_lesson

  def new
    @cs_sheet = CsSheet.new
    @student = current_user
    if @lesson.student_left?(current_user)
      @cs_sheet.score = 1
      @cs_sheet.reason_for_low_score = 'others'
    end
  end

  def create
    @cs_sheet = CsSheet.new(params[:cs_sheet])
    @cs_sheet.lesson = @lesson
    @cs_sheet.author = current_user
    if @cs_sheet.save
      redirect_to st_lesson_path(@lesson)
    else
      @student = current_user
      render action:"new"
    end
  end

  def show
    @cs_sheet = @lesson.cs_sheet_written_by(current_user)
  end

  private

    def prepare_lesson
      @lesson = current_user.lessons.find(params[:lesson_id])
    end
end

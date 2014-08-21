class St::ExamsController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'

  def index
    @exams = current_user.exams
  end

  def show
    month = Date.new(params[:year].to_i, params[:month].to_i)
    @exam = current_user.exams.of_subject(params[:subject_id]).of_month(month)
    @student_exam = current_user.exam_record_of(@exam)
  end

  def room
    month = Date.new(params[:year].to_i, params[:month].to_i)
    @student_exam = current_user.student_exams.find_by_subject_and_month(params[:subject_id], month)
    if @student_exam
      @student_exam.start!
      @exam = @student_exam.exam
      render layout:"plain"
    else
      redirect_to action:"index"
    end
  end
end

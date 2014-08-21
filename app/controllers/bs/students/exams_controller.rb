class Bs::Students::ExamsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'
  before_filter :prepare_student

  def index
    @exams = @student.exams_of_this_year
  end

  def show

  end

  # GET /bs/students/{student_id}/exams/edit
  # 個別の模試データではなく、複数の模試から「受ける・受けない」を選択するページ
  def edit
    @exams = @student.available_exams
  end

  def update
    @student.take_exams(params[:exams].keys)
    redirect_to action:"index"
  end
end

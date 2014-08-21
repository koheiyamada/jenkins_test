class GradeSubjectsController < ApplicationController
  before_filter do
    @grade = Grade.find(params[:grade_id])
  end

  def index
    @subjects = @grade.subjects
    respond_to do |format|
      format.json do
        render json: @subjects
      end
    end
  end

  def show
    @subject = @grade.subjects.find(params[:id])
    respond_to do |format|
      format.json do
        render json: @subject
      end
    end
  end
end

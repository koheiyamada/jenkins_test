class GradesController < ApplicationController
  def index
    @grades = Grade.order_by_grade
    respond_to do |format|
      format.json do
        render json: @grades
      end
    end
  end

  def show
    @grade = Grade.find(params[:id])
    respond_to do |format|
      format.json do
        render json: @grade
      end
    end
  end
end

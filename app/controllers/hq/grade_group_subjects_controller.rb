class Hq::GradeGroupSubjectsController < ApplicationController
  layout 'with_sidebar'

  before_filter do
    @grade_group = GradeGroup.find(params[:grade_group_id])
  end

  def index
    @subjects = @grade_group.subjects
  end

  def new
    @subject = @grade_group.subjects.build
  end

  def create
    @subject = @grade_group.subjects.build(params[:subject])
    if @subject.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
    @subject = @grade_group.subjects.find(params[:id])
  end

  def edit
    @subject = @grade_group.subjects.find(params[:id])
  end

  def update
    @subject = @grade_group.subjects.find(params[:id])
    if @subject.update_attributes(params[:subject])
      redirect_to action: :show
    else
      render :edit
    end
  end
end

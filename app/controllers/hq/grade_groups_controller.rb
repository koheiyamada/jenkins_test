class Hq::GradeGroupsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    @grade_groups = GradeGroup.by_group_order.page(params[:page])
  end

  def new
    @grade_group = GradeGroup.new
  end

  def show
    @grade_group = GradeGroup.find(params[:id])
  end

  def create
    @grade_group = GradeGroup.new(params[:grade_group])
    if @grade_group.save
      redirect_to action:"index"
    else
      render action:"new"
    end
  end

  def edit
    @grade_group = GradeGroup.find(params[:id])
  end

  def update
    @grade_group = GradeGroup.find(params[:id])
    @grade_group.attributes = params[:grade_group]
    @grade_group.grades = Grade.where(id:params[:grade_id])
    if @grade_group.save
      redirect_to action:"index"
    else
      render action:"edit"
    end
  end
end

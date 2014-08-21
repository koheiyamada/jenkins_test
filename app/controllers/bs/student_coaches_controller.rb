class Bs::StudentCoachesController < ApplicationController
  bs_user_only
  layout 'with_sidebar'
  block_coach only: [:new, :create]

  before_filter do
    @student = Student.find(params[:student_id])
    @bs = current_user.organization
  end

  def new
    @student_coache = StudentCoach.new
  end

  def create
    @coach = @bs.bs_users.find_by_id(params[:coach_id])
    if @coach.present?
      @coach.assign_student(@student)
      redirect_to action: :show
    else
      redirect_to({action: :new}, notice: t('student_coach.coach_not_found'))
    end
  end

  def show
    @coach = @student.coach
  end

  def edit

  end

  def update

  end
end

class Hq::StudentCoachesController < CoachesController
  hq_user_only
  before_filter do
    @student = Student.find(params[:student_id])
  end

  def show
    @student_coach = @student.student_coach
    p @student_coach
  end
end

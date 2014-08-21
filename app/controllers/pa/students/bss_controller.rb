class Pa::Students::BssController < ApplicationController
  parent_only
  layout 'with_sidebar'

  def show
    @student = current_user.students.find(params[:student_id])
    @bs = @student.organization
    @coach = @student.coach
  end
end

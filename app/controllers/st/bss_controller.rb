class St::BssController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'

  def show
    @bs = current_user.organization
    @coach = current_user.coach
  end
end

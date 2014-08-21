class Tu::RewardsController < ApplicationController
  tutor_only
  layout 'with_sidebar'

  def index
    @grades = Grade.order(:grade_order)
    @tutor = current_user
  end
end

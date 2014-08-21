class Bs::BasicLessonsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'

  def new
    @students = current_user.students.only_active.page(params[:page])
  end
end

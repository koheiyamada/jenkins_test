class Bs::StudentBasicLessonsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'
  before_filter :prepare_student

  def index
  end

  def show
  end
end

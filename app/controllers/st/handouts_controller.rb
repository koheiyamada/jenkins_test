class St::HandoutsController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'

  def index
  end

  def show
  end
end

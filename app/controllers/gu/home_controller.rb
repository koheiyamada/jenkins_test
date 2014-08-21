class Gu::HomeController < ApplicationController
  layout 'with_sidebar'

  def index
    redirect_to gu_tutors_path
  end
end

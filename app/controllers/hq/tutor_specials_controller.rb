class Hq::TutorSpecialsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :tutor
  layout 'with_sidebar'

  before_filter do
    @tutor = Tutor.find(params[:tutor_id])
  end

  def show

  end

  def update
    if params[:special] == '1'
      @tutor.become_special_tutor
    else
      @tutor.become_normal_tutor
    end
    if @tutor.valid?
      redirect_to action: :show
    else
      render :show
    end
  end
end

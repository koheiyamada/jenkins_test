class Hq::TutorTypesController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  before_filter :prepare_tutor

  def show
    redirect_to hq_tutor_path(@tutor)
  end

  def edit
    @tutor_type = @tutor.type
  end

  def update
    @tutor_type = params[:tutor_type]
    if @tutor_type.blank?
      render :edit
    elsif @tutor.change_type(@tutor_type)
      redirect_to hq_tutor_path(@tutor), notice: t('tutor.message.type_changed')
    else
      render :edit
    end
  end

end

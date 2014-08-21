class Hq::TutorAppFormsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control
  layout 'with_sidebar'

  def index
    @tutor_app_forms = TutorAppForm.under_application.order("created_at DESC").page(params[:page])
  end

  def processed
    @tutor_app_forms = TutorAppForm.processed.order("created_at DESC").page(params[:page])
  end

  def show
    @tutor_app_form = TutorAppForm.find(params[:id])
  end

  # POST /hq/ad/tutor_app_forms/1/create_tutor
  def create_tutor
    @tutor_app_form = TutorAppForm.find(params[:id])
    @tutor = @tutor_app_form.create_account!
    session[:new_tutor] = {id:@tutor.id, user_name:@tutor.user_name, password:@tutor.password}
    redirect_to action:"account_created"
  end

  # GET /hq/ad/tutor_app_forms/1/account_created
  def account_created
    @tutor_app_form = TutorAppForm.find(params[:id])
    @tutor = @tutor_app_form.tutor
    if session[:new_tutor]
      if session[:new_tutor][:id] && @tutor.id
        @tutor.password = session[:new_tutor][:password]
      else
        redirect_to action:"show"
      end
    else
      redirect_to action:"show"
    end
  end

  # POST /hq/tutor_app_forms/:id/reject
  def reject
    @tutor_app_form = TutorAppForm.find(params[:id])
    if @tutor_app_form.reject
      redirect_to hq_tutor_app_forms_path, notice: t('tutor_app_form.rejected')
    else
      render :show
    end
  end

  def destroy
    @tutor_app_form = TutorAppForm.where(id: params[:id]).first
    if @tutor_app_form
      @tutor_app_form.destroy
      logger.info "Tutor App Form of ID #{@tutor_app_form.id} is deleted."
    end
    redirect_to action: :processed
  end
end

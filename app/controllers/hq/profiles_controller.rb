class Hq::ProfilesController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def show
    @hq_user = current_user
  end

  def edit
    @hq_user = current_user
  end

  def update
    @hq_user = current_user
    if @hq_user.update_attributes(params[:hq_user])
      redirect_to action:'show'
    else
      render action:'edit'
    end
  end

  def change_password
    @hq_user = current_user
    if request.put?
      if @hq_user.update_attributes(params[:hq_user])
        sign_in @hq_user, :bypass => true
        redirect_to({action:'show'}, notice:t('messages.password_updated'))
      end
    end
  end

  def change_email
    @hq_user = current_user
    if request.post?
      @hq_user_form = UserRegistrationEmail.new
      @hq_user_form.user_id = current_user.id
      @hq_user_form.email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
      @hq_user_form.token = ''
      @hq_user_form.save
      HqUserMailer.change_email_hq_user(@hq_user_form.email,@hq_user_form.token).deliver
      redirect_to root_path
    end
  end

  def email_confirmation
    if params[:token].present?
      token = params[:token]
      if emailc = UserRegistrationEmail.find_by_token(token)
        @hq_user = emailc.user
        @hq_user.email = emailc.email
        @hq_user.save
        render :change_email_confirmation
      else
        render :change_email_confirmation_error
      end
    else
      render :change_email_confirmation_error
    end
  end

end

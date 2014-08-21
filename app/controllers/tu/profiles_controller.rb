class Tu::ProfilesController < ProfilesController
  tutor_only
  layout 'with_sidebar'

  def show
    @tutor = current_user
  end

  def edit
    @tutor = current_user
    if @tutor.current_address.blank?
      @tutor.build_current_address
    end
    if @tutor.hometown_address.blank?
      @tutor.build_hometown_address
    end
    @tutor_form = TutorUpdateForm.new(@tutor)
  end

  def update
    @tutor = current_user
    @tutor_form = TutorUpdateForm.new(@tutor)
    if @tutor_form.update(params)
      redirect_to tu_profile_path
    else
      render action:"edit"
    end
  end

  def change_email
    @tutor = current_user
    if request.post?
      temp_user = UserRegistrationForm.find(current_user.id)
      @tutor_form = UserRegistrationEmail.new
      @tutor_form.user_id = current_user.id
      @tutor_form.email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
      @tutor_form.token = temp_user.confirmation_token
      @tutor_form.save
      TutorMailer.change_email_tutor(@tutor_form.email,@tutor_form.token).deliver
      redirect_to root_path
    end
  end

  def email_confirmation
    if params[:token].present?
      token = params[:token]
      if emailc = UserRegistrationEmail.find_by_token(token)
        @tutor = emailc.user
        @tutor.email = emailc.email
        @tutor.save
        render :change_email_confirmation
      else
        render :change_email_confirmation_error
      end
    else
      render :change_email_confirmation_error
    end
  end

end

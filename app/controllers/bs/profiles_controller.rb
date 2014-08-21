class Bs::ProfilesController < ProfilesController
  bs_user_only
  layout 'with_sidebar'
  
  def show
    @bs_user = current_user
  end

  def edit
    @bs_user = current_user
    @bs_user.build_address if @bs_user.address.blank?
    @bs_user_form = BsUserUpdateForm.new(@bs_user)
  end

  def update
    @bs_user = current_user
    @bs_user_form = BsUserUpdateForm.new(@bs_user)
    if @bs_user_form.update(params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def change_email
    @bs_user = current_user
    if request.post?
      @bs_user_form = UserRegistrationEmail.new
      @bs_user_form.user_id = current_user.id
      @bs_user_form.email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
      @bs_user_form.token = ''
      @bs_user_form.save
      BsUserMailer.change_email_bs_user(@bs_user_form.email,@bs_user_form.token).deliver
      redirect_to root_path
    end
  end

  def email_confirmation
    if params[:token].present?
      token = params[:token]
      if emailc = UserRegistrationEmail.find_by_token(token)
        @bs_user = emailc.user
        @bs_user.email = emailc.email
        @bs_user.save
        render :change_email_confirmation
      else
        render :change_email_confirmation_error
      end
    else
      render :change_email_confirmation_error
    end
  end

end

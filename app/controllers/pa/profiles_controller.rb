class Pa::ProfilesController < ApplicationController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'
  after_filter :parent_updated, :only => :update

  def show
    @parent = current_user
  end

  def leave
    @parent = current_user
    if request.post?
      @parent.leave(reason:params[:reason])
      if @parent.errors.empty?
        sign_out @parent
        redirect_to "/left"
      else
      end
    end
  end

  def edit
    @edit_flg = true
    @parent = current_user
    if @parent.address.blank?
      @parent.build_address
    end
    @parent_form = ParentUpdateForm.new(@parent)
  end

  def update
    @parent = current_user
    @parent_form = ParentUpdateForm.new(@parent)
    if @parent_form.update(params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def change_password
    @parent = current_user
    if request.put?
      if @parent.update_attributes(params[:parent])
        sign_in @parent, :bypass => true
        redirect_to({action:'show'}, notice:t('messages.password_updated'))
      end
    end
  end

  def change_email
    @parent = current_user
    if request.post?
      temp_user = UserRegistrationForm.find(current_user.id)
      @parent_form = UserRegistrationEmail.new
      @parent_form.user_id = current_user.id
      @parent_form.email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
      @parent_form.token = temp_user.confirmation_token
      @parent_form.save
      ParentMailer.change_email_parent(@parent_form.email,@parent_form.token).deliver
      redirect_to root_path
    end
  end

  def email_confirmation
    if params[:token].present?
      token = params[:token]
      if emailc = UserRegistrationEmail.find_by_token(token)
        @parent = emailc.user
        @parent.email = emailc.email
        @parent.save
        render :change_email_confirmation
      else
        render :change_email_confirmation_error
      end
    else
      render :change_email_confirmation_error
    end
  end

  private

    def parent_updated
      Mailer.send_mail(:parent_updated, current_user)
    end
end

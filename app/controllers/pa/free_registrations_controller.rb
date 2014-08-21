class Pa::FreeRegistrationsController < FreeRegistrationsController
  parent_only

  layout 'registration-centered'

  def new
    if SystemSettings.free_mode?
      @parent = current_user
      unless @parent.active?
        @parent.activate
        @parent.to_free
        sign_in @parent, :bypass => true
      else
        redirect_to root_path and return
      end
      redirect_to action: :complete and return
   	end
  end
	
  def complete
    password = User.generate_password
    current_user.password = password
    current_user.save
    sign_in current_user,:bypass => true
    UserMailer.parent_created(current_user, password).deliver
  end
end

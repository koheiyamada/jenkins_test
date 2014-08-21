class St::FreeRegistrationsController < FreeRegistrationsController
  student_only

  layout 'registration-centered'

  def new
    if SystemSettings.free_mode?
      @student = current_user
      unless @student.active?
        @student.free_registration
        sign_in @student, :bypass => true
      else
        redirect_to root_path
      end
      redirect_to action: :complete
   	end
  end
	
  def complete
  end
end

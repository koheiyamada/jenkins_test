class RegistrationController < ApplicationController

  class RegistrationState
    attr_accessor :under_20, :has_payment_method

    def user_type
      under_20 ? 'Parent' : 'Student'
    end
  end

  before_filter :prepare_state, except: :confirmation1
  before_filter :state_required, except: [:confirmation1, :mail_certification_complete]

  def confirmation1
    session[:registration] = RegistrationState.new
  end

  def process_confirmation1
    @state.under_20 = params[:under_20] == '1'
    @free_mode = SystemSettings.free_mode?
    if !@state.under_20 && @free_mode
      redirect_to action: :mail_certification and return;
    else
      redirect_to action: :confirmation2 and return;
    end
  end

  def confirmation2
    @free_mode = SystemSettings.free_mode?
  end

  def process_confirmation2
    @state.has_payment_method = params[:has_payment_method] == '1'
    if @state.has_payment_method
      redirect_to action: :mail_certification
    else
      if @free_mode = SystemSettings.free_mode?
        @checkbox_validate = true
        render action: :confirmation2
      else
        redirect_to action: :confirmation1
      end
    end
  end

  def mail_certification
    @email_confirmation_form = email_confirmation_class.new
  end

  def process_mail_certification
    @email_confirmation_form = email_confirmation_class.new(params[:email_confirmation_form])
    if @email_confirmation_form.save
      redirect_to action: :mail_certification_complete
    else
      render :mail_certification
    end
  end

  def mail_certification_complete
    session[:registration] = nil
  end

  private

    def prepare_state
      @state = session[:registration]
    end

    def state_required
      if @state.blank?
        redirect_to action: :confirmation1
      end
    end

    def email_confirmation_class
      case @state.user_type
      when 'Parent'
        ParentEmailConfirmationForm
      when 'Student'
        StudentEmailConfirmationForm
      else
        EmailConfirmationForm
      end
    end
end

class St::PaymentMethodsController < PaymentMethodsController
  before_filter :student_and_hq_user_only

  layout 'with_sidebar'

  ###現在の支払方法
  def current
    @target_user = proxy_current_user params[:uid]

    @payment_method = @target_user.payment_method
    if @payment_method.is_a? YuchoPayment
      @yucho_account = @target_user.yucho_account
    elsif @payment_method.is_a? CreditCardPayment
      @card_number = @target_user.get_available_card_number
    end
  end

  def new
    @payment_method = current_user.payment_method
    if @payment_method.present?
      if @payment_method.is_a? CreditCardPayment
        redirect_to st_credit_card_path
      elsif @payment_method.is_a? YuchoPayment
        redirect_to st_bank_account_path
      elsif @payment_method.is_a? DummyPaymentMethod
        redirect_to new_st_free_registration_path
      end
    end
  end

  private
  def student_and_hq_user_only
    authenticate_user!
    if ["student?", "hq_user?"].map {|mth| current_user.send mth}.none?
      redirect_to new_user_session_path
    end
  end

end

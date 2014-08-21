class Pa::PaymentMethodsController < PaymentMethodsController
  before_filter :parent_and_hq_user_only
  before_filter :delete_student_id_in_session
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

  private
    def delete_student_id_in_session
      session[:student_id] = nil #=> 支払方法変更時にセッションに残った受講者IDが一般会員登録されてしまわないように消去
    end

    def parent_and_hq_user_only
      authenticate_user!
      if ["parent?", "hq_user?"].map {|mth| current_user.send mth}.none?
        redirect_to new_user_session_path
      end
    end

end

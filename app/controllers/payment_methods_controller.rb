class PaymentMethodsController < ApplicationController
  def show
    if current_user.has_credit_card?
      redirect_to pa_credit_card_path
    elsif current_user.bank_account.present?
      redirect_to pa_bank_account_path
    else
      redirect_to action: :new
    end
  end

  def new
    @payment_method = current_user.payment_method
    if @payment_method.present?
      if @payment_method.is_a? CreditCardPayment
        redirect_to pa_credit_card_path
      else
        redirect_to pa_bank_account_path
      end
    end
  end

  def payment_method_change
    @target_user = proxy_current_user params[:uid]

    if params[:credit_or_yucho] == 'credit_card'
      @credit_card = CreditCard.new(params[:credit_card])
      month = params[:expire]["(2i)"].to_i
      year = params[:expire]["(1i)"].to_i
      if month != 0 && year != 0
        expire = Time.new(year,month)
      else
        expire = ''
      end
      @credit_card.number = params[:number]
      @credit_card.expire = expire
      @credit_card.security_code = params[:security_code]

      if @credit_card.valid?
        if @target_user.credit_card_register(
          number: @credit_card.number,
          expire: "%02d/%02d" % [
            @credit_card.expire.month,
            @credit_card.expire.year,
          ],
          security_code: @credit_card.security_code)
          @target_user.update_attribute(:has_credit_card, true)
          @target_user.on_credit_card_registered
          if @target_user.parent?
            redirect_to confirmation_credit_pa_payments_path
          else
            redirect_to confirmation_credit_st_payments_path
          end
        else
          render :action => 'current'
        end
      else
        render :action => 'current'
      end

    else
      @temp_yucho_account = TempYuchoAccount.new
      @temp_yucho_account.kigo1 = params[:kigo1]
      @temp_yucho_account.kigo2 = params[:kigo2]
      @temp_yucho_account.bango = params[:bango]
      @temp_yucho_account.account_holder_name = params[:account_holder_name]
      @temp_yucho_account.account_holder_name_kana = params[:account_holder_name_kana]

      if @temp_yucho_account.save
        @target_user.create_yucho_account_appilcation_with(@temp_yucho_account)
        if @target_user.parent?
          redirect_to confirmation_yucho_pa_payments_path
        else
          redirect_to confirmation_yucho_st_payments_path
        end
      else
        render :action => 'current'
      end
    end
  end

  private

  def proxy_current_user(uid)
    if ! current_user.hq_user? && uid
      raise 'Proxy must be HQ'
    end
    if current_user.hq_user?
      User.find uid
    else
      current_user
    end
  end

end

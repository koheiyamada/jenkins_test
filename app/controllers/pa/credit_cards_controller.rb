class Pa::CreditCardsController < CreditCardsController
  parent_only
  layout :layout_for_user

  around_filter :sign_in_again, :only => :register

  def show
    unless current_user.has_credit_card?
      redirect_to new_pa_credit_card_path
    end
    if current_user.active?
      render layout: 'with_sidebar'
    end
  end

  def new
  end

  def registered
    if session[:from_free_user] == true
      @from_free_user = true
    else
      @from_free_user = false
    end
  end
end

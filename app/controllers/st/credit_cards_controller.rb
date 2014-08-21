class St::CreditCardsController < CreditCardsController
  student_only
  before_filter :independent_student_only
  around_filter :sign_in_again, :only => :register
  layout :layout_for_user

  def show
    unless current_user.has_credit_card?
      redirect_to new_st_credit_card_path
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

  private

    def independent_student_only
      unless current_user.independent?
        redirect_to root_path
      end
    end
end

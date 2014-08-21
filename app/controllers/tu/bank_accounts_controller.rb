class Tu::BankAccountsController < BankAccountsController
  tutor_only

  def new
    if params[:bank]
      bank = Bank.find_by_code(params[:bank])
      if bank.present?
        @bank = Bank.special.find_by_code params[:bank]
        @bank_account = @bank.new_account
        render new_template
      end
    else
      @bank_account = subject.bank_account
      @banks = Bank.special
    end
  end

  private

    def subject
      current_user
    end
end

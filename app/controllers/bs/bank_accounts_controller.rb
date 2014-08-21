class Bs::BankAccountsController < BankAccountsController
  bs_user_only

  private

  def subject
    current_user.organization
  end
end

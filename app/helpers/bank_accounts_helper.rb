module BankAccountsHelper
  def account_type(bank_account)
    t("bank_account.account_types.#{bank_account.account_type}")
  end

  def bank_name(bank_account)
    bank_account.bank_name
  end
end
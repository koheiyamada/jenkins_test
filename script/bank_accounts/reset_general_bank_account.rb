GeneralBankAccount.transaction do
  GeneralBankAccount.all.each do |account|
    bank_account = account.bank_account
    if bank_account.present?
      bank = bank_account.bank
      if bank.present?
        account.bank_name = bank.name
        account.save!
      end
    end
  end
end

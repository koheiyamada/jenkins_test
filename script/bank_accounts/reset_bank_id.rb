yucho = Bank.find_by_code 'yucho'
mitsu = Bank.find_by_code 'mitsubishi_tokyo_ufj'

ActiveRecord::Base.transaction do
  BankAccount.all.each do |bank_account|
    if bank_account.bank.blank?
      account = bank_account.account
      if account.is_a? YuchoAccount
        puts "Bank account of user #{bank_account.owner.id} is Yucho"
        bank_account.bank = yucho
      elsif account.is_a? MitsubishiTokyoUfjAccount
        puts "Bank account of user #{bank_account.owner.id} is MitsubishiTokyoUfj"
        bank_account.bank = mitsu
      else
        puts "Bank account of user #{bank_account.owner.id} is ???"
      end
      bank_account.save!
    end
  end
end

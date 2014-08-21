class BankAccountService
  include Loggable

  def initialize(owner)
    raise 'BankAccountOwner only' unless owner.is_a?(BankAccountOwner)
    @owner = owner
  end

  attr_reader :owner

  def create_general_bank_account!(params)
    GeneralBankAccount.transaction do
      if owner.bank_account.present?
        owner.bank_account.destroy
      end
      account = GeneralBankAccount.create!(params)
      account.create_bank_account!(owner: owner)
      account
    end
  end
end
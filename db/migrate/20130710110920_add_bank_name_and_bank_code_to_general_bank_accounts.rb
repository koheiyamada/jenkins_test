class AddBankNameAndBankCodeToGeneralBankAccounts < ActiveRecord::Migration
  def change
    add_column :general_bank_accounts, :bank_name, :string
    add_column :general_bank_accounts, :bank_code, :string

    message =<<-END
    ###########################################################
    #  RUN: script/bank_accounts/reset_general_bank_account.rb
    ###########################################################
    END
  end
end

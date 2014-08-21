class ResetBankId < ActiveRecord::Migration
  def up
    require Rails.root.join 'script/bank_accounts/reset_bank_id'
  end

  def down
  end
end

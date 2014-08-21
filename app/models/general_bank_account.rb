class GeneralBankAccount < ActiveRecord::Base
  has_one :bank_account, :as => :account

  attr_accessible :account_holder_name, :account_holder_name_kana,
                  :account_number, :account_type, :bank_id, :branch_code, :branch_name,
                  :bank_name, :bank_code


  validates_presence_of :account_holder_name, :account_holder_name_kana,
                        :branch_code, :branch_name, :account_number

  validates_inclusion_of :account_type, in: %w(savings checking)

  validates_format_of :account_number, with: /\A\d+\Z/
end

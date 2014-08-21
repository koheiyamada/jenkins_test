class BankAccount < ActiveRecord::Base
  attr_accessible :account, :owner, :bank
  belongs_to :owner, :polymorphic => true
  belongs_to :account, :polymorphic => true, :dependent => :destroy
  belongs_to :bank

  validates_presence_of :owner_id, :owner_type, :account_id, :account_type

  def yucho?
    account_type == YuchoAccount.name
    #account.is_a? YuchoAccount
  end
end

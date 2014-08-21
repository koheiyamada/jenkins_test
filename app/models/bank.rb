# coding: utf-8

class Bank < ActiveRecord::Base

  class << self
    def special_bank_codes
      %w(yucho mitsubishi_tokyo_ufj)
    end
  end

  scope :special, where(code: special_bank_codes)

  has_many :bank_accounts
  #has_many :general_bank_accounts, :through => :bank_accounts

  attr_accessible :code, :name

  validates_presence_of :name, :code
  validates_format_of :code, :with => /\A[a-z][a-z0-9_]{0,99}\Z/
  validates_uniqueness_of :code
  validates_uniqueness_of :name

  before_destroy do
    bank_accounts.empty? # この銀行の口座が存在する場合は削除しない
  end

  def account_class
    if special?
      eval(code.camelcase + 'Account')
    else
      GeneralBankAccount
    end
  end

  def create_account(attr)
    account_class.create(attr)
  end

  def new_account(params={})
    account_class.new(params)
  end

  def special?
    Bank.special_bank_codes.include? code
  end
end

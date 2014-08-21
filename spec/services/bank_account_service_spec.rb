# coding:utf-8

require 'spec_helper'

describe BankAccountService do
  let(:bs) {FactoryGirl.create(:bs)}

  def attrs
    FactoryGirl.attributes_for(:general_bank_account)
  end

  describe '#create_general_bank_account' do
    it 'GeneralBankAccountが増える' do
      s = BankAccountService.new(bs)
      expect {
        s.create_general_bank_account!(attrs)
      }.to change(GeneralBankAccount, :count).by(1)
    end

    it '作成された口座はオーナーに関連付けられる' do
      s = BankAccountService.new(bs)
      account = s.create_general_bank_account!(attrs)
      bs.reload.bank_account.account.should == account
    end

  end
end
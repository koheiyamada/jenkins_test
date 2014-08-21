# coding:utf-8
require 'spec_helper'

describe Bank do
  subject {Bank.first}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:yucho) {Bank.find_by_code 'yucho'}
  let(:mitsu) {Bank.find_by_code 'mitsubishi_tokyo_ufj'}
  let(:bank) {FactoryGirl.create(:bank)}

  describe '#account_class' do
    it '口座のクラスを返す' do
      yucho.account_class.should == YuchoAccount
      mitsu.account_class.should == MitsubishiTokyoUfjAccount
    end
  end

  describe '#create_account' do
    before(:each) do
      yucho.should be_persisted
      mitsu.should be_persisted
    end

    it 'ゆうちょ' do
      account = yucho.create_account(kigo1: '12345', bango: '12345678',
                                     account_holder_name: 'aaa', account_holder_name_kana: 'bbb')
      account.should be_persisted
      account.should be_a(YuchoAccount)
    end

    it '三菱東京UFJ' do
      account = mitsu.create_account(branch_name: 'branch',
                                     branch_code: '123',
                                     account_number: '123456789',
                                     account_holder_name: 'aaa',
                                     account_holder_name_kana: 'bbb')
      account.should be_persisted
      account.should be_a(MitsubishiTokyoUfjAccount)
    end

    it 'その他の銀行' do
      bank = FactoryGirl.create(:bank, code: 'mizuho', name: 'MIZUHO')
      account = bank.create_account(branch_name: 'branch',
                                    branch_code: '123',
                                    account_number: '123456789',
                                    account_holder_name: 'aaa',
                                    account_holder_name_kana: 'bbb')
      account.should be_persisted
      account.should be_a(GeneralBankAccount)
    end
  end

  describe 'ゆうちょ銀行' do
    subject {FactoryGirl.create(:bank, code: 'yucho', name:'hoge')}
  end

  describe '#destroy' do
    context '口座がが存在する' do
      before(:each) do
        bank.stub_chain('bank_accounts.empty?'){false}
      end

      it '削除できない' do
        expect {
          bank.destroy
        }.not_to change(Bank, :count)
      end
    end

    context '口座がひとつもない' do
      before(:each) do
        bank.stub_chain('bank_accounts.empty?'){true}
      end

      it '削除される' do
        expect {
          bank.destroy
        }.to change(Bank, :count).by(-1)
      end
    end
  end
end

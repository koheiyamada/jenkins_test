# coding:utf-8
require 'spec_helper'

describe BankAccount do
  let(:tutor) {FactoryGirl.create(:tutor)}

  describe 'ゆうちょ口座' do
    subject {
      tutor.create_account_of_bank('yucho', attrs)
    }

    def attrs
      FactoryGirl.attributes_for(:yucho_account)
    end

    it 'BankAccountのインスタンスを返す' do
      subject.is_a?(BankAccount).should be_true
    end

    it 'YuchoAccountを持つ' do
      subject.account.class.should == YuchoAccount
    end

    it 'YuchoAccountは設定した値を持つ' do
      yucho = subject.account
      yucho.kigo1.should == attrs[:kigo1]
      yucho.kigo2.should == attrs[:kigo2]
      yucho.bango.should == attrs[:bango]
      yucho.account_holder_name.should == attrs[:account_holder_name]
      yucho.account_holder_name_kana.should == attrs[:account_holder_name_kana]
    end

    describe '削除する' do
      before(:each) do
        subject # 作成
      end

      it 'まとめて消える' do
        expect {
          subject.destroy
        }.to change(YuchoAccount, :count).by(-1)
      end
    end
  end


  describe '三菱東京UFJ銀行の口座' do
    subject {
      tutor.create_account_of_bank('mitsubishi_tokyo_ufj', attrs)
    }

    def attrs
      FactoryGirl.attributes_for(:mitsubishi_tokyo_ufj_account)
    end

    it 'BankAccountのインスタンスを返す' do
      subject.is_a?(BankAccount).should be_true
    end

    it 'MitsubishiTokyoUfjAccountを持つ' do
      subject.account.class.should == MitsubishiTokyoUfjAccount
    end

    it 'MitsubishiTokyoUfjAccountは設定した値を持つ' do
      account = subject.account
      account.branch_name.should == attrs[:branch_name]
      account.branch_code.should == attrs[:branch_code]
      account.account_number.should == attrs[:account_number]
      account.account_holder_name.should == attrs[:account_holder_name]
      account.account_holder_name_kana.should == attrs[:account_holder_name_kana]
    end

    describe '削除する' do
      before(:each) do
        subject # 作成
      end

      it 'まとめて消える' do
        expect {
          subject.destroy
        }.to change(MitsubishiTokyoUfjAccount, :count).by(-1)
      end
    end
  end
end

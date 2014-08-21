# coding:utf-8
require 'spec_helper'

describe YuchoAccount do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}

  describe '登録する' do
    describe 'チューターのゆうちょ銀行口座を作る' do
      it '記号１は要る' do
        account = FactoryGirl.build(:yucho_account, kigo1: nil)
        account.should_not be_valid
      end

      it '記号2はオプション' do
        account = FactoryGirl.build(:yucho_account, kigo2: nil)
        account.should be_valid
      end

      it '番号は必須' do
        account = FactoryGirl.build(:yucho_account, bango: nil)
        account.should_not be_valid
      end

      it '口座名義人' do
        account = FactoryGirl.build(:yucho_account, account_holder_name: nil)
        account.should_not be_valid
      end

      it '口座名義人（カナ）' do
        account = FactoryGirl.build(:yucho_account, account_holder_name: nil)
        account.should_not be_valid
      end

    end

    describe 'BSのゆうちょ口座を登録する' do
    end
  end

  it '全角数字は半角数字に変換する' do
    account = FactoryGirl.build(:yucho_account, kigo1: '１２３４５', kigo2: '１', bango: '１２３４５６７８')
    account.should be_valid
    account.kigo1.should == '12345'
    account.kigo2.should == '1'
    account.bango.should == '12345678'
  end

  it '番号欄は6~8桁を受け付ける' do
    FactoryGirl.build(:yucho_account, bango:     '12345').should_not be_valid
    FactoryGirl.build(:yucho_account, bango:    '123456').should be_valid
    FactoryGirl.build(:yucho_account, bango:   '1234567').should be_valid
    FactoryGirl.build(:yucho_account, bango:  '12345678').should be_valid
    FactoryGirl.build(:yucho_account, bango: '123456789').should_not be_valid
  end

  it '番号が8桁未満の場合はゼロで埋める' do
    FactoryGirl.create(:yucho_account, bango:    '123456').bango.should == '00123456'
    FactoryGirl.create(:yucho_account, bango:   '1234567').bango.should == '01234567'
    FactoryGirl.create(:yucho_account, bango:  '12345678').bango.should == '12345678'
  end
end

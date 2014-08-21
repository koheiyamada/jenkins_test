# coding:utf-8
require 'spec_helper'

describe MitsubishiTokyoUfjAccount do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}

  describe '登録する' do
    def attrs
      FactoryGirl.attributes_for(:mitsubishi_tokyo_ufj_account)
    end

    describe 'チューターのゆうちょ銀行口座を作る' do
      it '支店名は要る' do
        MitsubishiTokyoUfjAccount.new(attrs.merge(branch_name: nil)).should_not be_valid
      end

      it '支店番号は要る' do
        MitsubishiTokyoUfjAccount.new(attrs.merge(branch_code: nil)).should_not be_valid
      end

      it '口座番号は必須' do
        MitsubishiTokyoUfjAccount.new(attrs.merge(account_number: nil)).should_not be_valid
      end

      it '口座名義人' do
        MitsubishiTokyoUfjAccount.new(attrs.merge(account_holder_name: nil)).should_not be_valid
      end

      it '口座名義人（カナ）' do
        MitsubishiTokyoUfjAccount.new(attrs.merge(account_holder_name_kana: nil)).should_not be_valid
      end
    end

    describe 'BSのゆうちょ口座を登録する' do
    end
  end
end

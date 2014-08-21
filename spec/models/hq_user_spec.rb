# coding:utf-8

require 'spec_helper'

describe HqUser do
  let(:student) {FactoryGirl.create(:active_student)}

  it 'emailはなんでもよい' do
    FactoryGirl.build(:hq_user, email: 'shimokawa@gmail.com').should be_valid
    FactoryGirl.build(:hq_user, email: 'shimokawa@yahoo.co.jp').should be_valid
    FactoryGirl.build(:hq_user, email: 'shimokawa@docomo.ne.jp').should be_valid
  end

  it '重複するニックネームはダメ' do
    FactoryGirl.create(:hq_user, nickname: 'hoge').should be_valid
    FactoryGirl.build(:hq_user, nickname: 'hoge').should_not be_valid
  end

  describe '削除' do
    it '会計情報を削除しない' do
      FactoryGirl.create(:account_journal_entry, owner: student)

      hq_user = FactoryGirl.create(:hq_user)
      expect {
        hq_user.destroy
      }.not_to change(Account::JournalEntry, :count)
    end
  end
end

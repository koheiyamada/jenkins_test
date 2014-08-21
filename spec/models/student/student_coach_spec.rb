# coding:utf-8

require 'spec_helper'

describe Student do
  subject{FactoryGirl.create(:student)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:bs_user) {FactoryGirl.create(:bs_user, organization: bs)}

  before(:each) do
    bs.representative = bs_user
    bs.save!
  end

  describe '#reset_coach' do
    before(:each) do
      subject # 事前に一度ロードしておく（作成時の処理をカウントしないために）
    end

    it '現在所属するBSの代表者がコーチになる' do
      expect {
        subject.organization = bs
        subject.save!
      }.to change{subject.reload.coach}.from(nil).to(bs.representative)
    end

    context '現在とあるBSに所属している場合' do
      before(:each) do
        subject.organization = bs
        subject.save!
      end

      describe '所属が本部に変わる' do
        it '教育コーチは空になる' do
          subject.organization = Headquarter.instance
          subject.save!
          subject.reload.coach.should be_nil
        end
      end
    end
  end
end
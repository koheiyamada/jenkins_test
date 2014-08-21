# coding:utf-8

require 'spec_helper'

describe Student do
  subject{FactoryGirl.create(:student)}

  describe '住所変更' do
    it '#reset_coachが呼ばれる' do
      subject # 事前に一度ロードしておく（作成時の処理をカウントしないために）
      Student.any_instance.should_receive(:reset_coach)

      bs = FactoryGirl.create(:bs)
      subject.address.attributes = FactoryGirl.attributes_for(:address2)
      BsCustomer.any_instance.stub(:resolve_bs_by_address){bs}
      subject.save!
    end
  end
end
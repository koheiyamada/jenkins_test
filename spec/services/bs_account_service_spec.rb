# coding:utf-8
require 'spec_helper'

describe BsAccountService do
  let(:bs) {FactoryGirl.create(:bs)}
  let(:bs_user) {FactoryGirl.create(:bs_user, organization: bs)}
  subject {BsAccountService.new(bs)}

  describe '#deactivate' do
    it 'BSが非アクティブ化される' do
      expect{
        subject.deactivate
      }.to change{subject.bs.active?}.from(true).to(false)
    end

    it '所属する生徒は本部所属に切り替わる' do
      student = FactoryGirl.create(:student, organization: bs)

      expect {
        subject.deactivate
      }.to change{student.reload.organization}.from(bs).to(Headquarter.instance)
    end

    context '代表者がいる' do
      before(:each) do
        bs.set_representative bs_user
        bs.representative.should == bs_user
      end

      it '代表者アカウントは使えなくなる' do
        expect {
          BsAccountService.new(bs).deactivate.should be_true
        }.to change{bs_user.reload.active?}.from(true).to(false)
      end
    end

    context '教育コーチがいる' do
      before(:each) do
        FactoryGirl.create(:coach, organization: bs)
        bs.reload.coaches.should be_present
      end

      it '教育コーチアカウントは使えなくなる' do
        bs.coaches.all?{|c| c.active?}.should be_true
        subject.deactivate
        bs.coaches.reload.any?{|c| c.active?}.should be_false
      end
    end
  end

  describe '#reactivate' do
    before(:each) do
      bs.set_representative bs_user
      bs.reload
      subject.deactivate.should be_true
      bs.should_not be_active
      bs_user.reload.should_not be_active
    end

    it '退会したBSをアクティブ化する' do
      expect {
        subject.reactivate
      }.to change{bs.reload.active?}.from(false).to(true)
    end

    it '退会したBSの代表者アカウントをアクティブ化する' do
      expect {
        subject.reactivate
      }.to change{bs_user.reload.active?}.from(false).to(true)
    end
  end
end
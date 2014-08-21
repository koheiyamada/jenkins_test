# coding:utf-8

require 'spec_helper'

describe TutorDailyAvailableTimeService do
  let(:tutor){FactoryGirl.create(:tutor)}
  subject{TutorReferenceService.new(tutor)}

  describe '#assign_reference' do
    it 'チューターは紹介者になれる' do
      tutor2 = FactoryGirl.create(:tutor)
      subject.assign_reference(tutor2.user_name).should == tutor2
    end

    it 'BSは紹介者になれる' do
      bs_user = FactoryGirl.create(:bs_user)
      subject.assign_reference(bs_user.user_name).should == bs_user
    end

    it '本部アカウントは紹介者になれる' do
      hq_user = FactoryGirl.create(:hq_user)
      subject.assign_reference(hq_user.user_name).should == hq_user
    end

    it '受講者は紹介者になれない' do
      student = FactoryGirl.create(:active_student)
      subject.assign_reference(student.user_name).should be_nil
    end

    it '保護者は紹介者になれない' do
      parent = FactoryGirl.create(:active_parent)
      subject.assign_reference(parent.user_name).should be_nil
    end
  end
end
# coding:utf-8
require 'spec_helper'

describe SpecialTutor do
  subject {FactoryGirl.create(:special_tutor)}

  describe '.create' do
    it '#special? => true' do
      subject.should be_special
    end

    it '#regular? => true' do
      subject.should be_regular
    end

    it '#beginner? => false' do
      subject.should_not be_beginner
    end

    it 'info.status => regular' do
      subject.info.status.should == 'regular'
    end
  end

  describe '#update_monthly_journal_entries!' do
    it 'スペシャルチューター費が増える' do
      expect {
        subject.update_monthly_journal_entries!(Date.today.year, Date.today.month)
      }.to change(Account::SpecialTutorFee, :count).by(1)
    end
  end

  describe '#become_beginner' do
    it '仮登録になる' do
      subject.become_beginner.should be_true
      tutor = Tutor.find(subject.id)
      tutor.class.name.should == 'Tutor'
      p tutor.info
      tutor.should be_beginner
    end

    it '時給も戻る' do
      subject.become_beginner
      subject.hourly_wage.should == TutorPrice.beginner_tutor_default_hourly_wage
    end
  end
end

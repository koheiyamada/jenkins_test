# encoding:utf-8
require 'spec_helper'

describe Student do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:hq_user) {FactoryGirl.create(:hq_user)}
  let(:student) {FactoryGirl.create(:active_student)}

  describe '.to_pay_entry_fee' do
    it '入会31日目以降の入会金未払いの受講者を返す' do
      s1 = FactoryGirl.create(:active_student, enrolled_at: 31.days.ago.to_time)
      s2 = FactoryGirl.create(:active_student, enrolled_at: 30.days.ago.to_time)
      s3 = FactoryGirl.create(:active_student, enrolled_at: 31.days.ago.to_time)
      s3.create_entry_fee!
      s4 = FactoryGirl.create(:active_student, enrolled_at: 32.days.ago.to_time)
      s5 = FactoryGirl.create(:active_student, enrolled_at: 30.days.ago.to_time)
      s5.create_entry_fee!

      Student.count.should == 5
      students = Student.to_pay_entry_fee
      students.count.should == 2
      [s1, s4].all?{|s| students.include?(s)}.should be_true
    end

    it '退会した受講者には課金しない' do
      s1 = FactoryGirl.create(:active_student, enrolled_at: 31.days.ago.to_time)
      s1.leave('boring')

      students = Student.to_pay_entry_fee
      students.count.should == 0
    end
  end
end

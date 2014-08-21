# coding:utf-8
require 'spec_helper'

describe StudentMembershipService do
  let(:student){FactoryGirl.create(:student)}
  subject{StudentMembershipService.new(student)}

  describe '#enrolled_month' do
    context '入会日が締め日よりも前の場合' do
      before(:each) do
        @t = student.created_at
        student.stub(:created_at){@t.change(day: SystemSettings.cutoff_date)}
      end

      it 'その月を返す' do
        month = subject.enrolled_month
        month.year.should == @t.year
        month.month.should == @t.month
      end
    end

    context '入会日が締め日のあとの場合' do
      before(:each) do
        @t = student.created_at
        student.stub(:created_at){@t.change(day: SystemSettings.cutoff_date + 1)}
      end

      it '翌月を返す' do
        month = subject.enrolled_month
        t = @t.next_month
        month.year.should == t.year
        month.month.should == t.month
      end
    end
  end
end
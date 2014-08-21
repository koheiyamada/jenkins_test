# coding:utf-8

require 'spec_helper'

describe LessonSettings do
  it '自動的に作られる' do
    expect {
      LessonSettings.tutor_entry_period_before_start_time.should == 10
    }.to change(LessonSettings, :count).from(0).to(1)
  end

  describe '.update' do
    before(:each) do
      LessonSettings.tutor_entry_period_before_start_time
    end

    it '値が更新される' do
      expect {
        LessonSettings.update(tutor_entry_period_before_start_time: 5).should be_true
      }.to change{LessonSettings.tutor_entry_period_before_start_time}.from(10).to(5)
    end

    it 'インスタンスが増える' do
      expect {
        LessonSettings.update(tutor_entry_period_before_start_time: 5)
      }.to change(LessonSettings, :count).by(1)
    end
  end
end

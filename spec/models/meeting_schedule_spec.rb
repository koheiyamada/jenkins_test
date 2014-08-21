# coding:utf-8
require 'spec_helper'

describe MeetingSchedule do
  it '未来の時刻のみ受け付ける' do
    MeetingSchedule.new(datetime: -1.second.from_now).should_not be_valid
    MeetingSchedule.new(datetime: 1.second.from_now).should be_valid
  end
end

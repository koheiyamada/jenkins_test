# coding:utf-8

require "spec_helper"

describe BsUserMailer do
  describe '#meeting_schedule_selected' do
    let(:bs_user){FactoryGirl.create(:bs_user)}
    let(:student){FactoryGirl.create(:student)}
    let(:parent){FactoryGirl.create(:parent)}

    before(:each) do
      @meeting = FactoryGirl.create(:meeting, creator: bs_user)
      @meeting.members << bs_user
      @meeting.members << student
      @meeting.schedules << MeetingSchedule.new(datetime: 1.day.from_now)
      @meeting.finish_registering
    end

    it 'メールを作成できる' do
      meeting_member = @meeting.meeting_members.find_by_user_id(student.id)
      schedule = @meeting.schedules.first
      mail = BsUserMailer.meeting_schedule_selected(bs_user, meeting_member, schedule)
    end
  end
end

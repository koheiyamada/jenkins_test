# coding: utf-8

require 'spec_helper'

describe MeetingReport do
  let(:hq_user){ FactoryGirl.create(:hq_user) }
  let(:student){ FactoryGirl.create(:student) }
  let(:meeting){ FactoryGirl.create(:meeting, members: [hq_user, student], datetime: 1.hour.from_now) }

  describe 'meeting#build_meeting_report 作成する' do
    it '著者、面談、内容がいる' do
      meeting.build_meeting_report(author: hq_user, text: 'Hello').should be_valid
    end

    it '著者がいる' do
      meeting.build_meeting_report(author: nil, text: 'Hello').should_not be_valid
    end

    it '内容がいる' do
      meeting.build_meeting_report(author: hq_user, text: nil).should_not be_valid
    end
  end
end

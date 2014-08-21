# encoding:utf-8
require 'spec_helper'

describe '面談を登録する' do
  before(:each) do
    hq_user = FactoryGirl.create(:hq_user)
    login_as(hq_user)

    FactoryGirl.create(:active_student)
  end

  let(:student){FactoryGirl.create(:student)}
  let(:tutor){FactoryGirl.create(:tutor)}
  let(:subject){FactoryGirl.create(:subject)}

  it '面談を登録する' do
    visit '/hq/meetings/new'

    click_link '二者面談'

    meeting = Meeting.last

    current_path.should == "/hq/meetings/#{meeting.id}/forms/member_type"

    click_link '受講者'

    current_path.should == "/hq/meetings/#{meeting.id}/forms/student"

    click_link '選択'

    current_path.should == "/hq/meetings/#{meeting.id}/forms/schedule"

    #dates = (1..3).map{|i| i.days.from_now}
    time = 1.day.from_now

    find(:css, 'form input[name="date"]').set time.to_date.iso8601
    select time.hour.to_s, from: 'time_hour'
    select (time.min / 5 * 5).to_s, from: 'time_minute'
    click_button '追加'

    current_path.should == "/hq/meetings/#{meeting.id}/forms/schedule"

    click_link '次へ'

    current_path.should == "/hq/meetings/#{meeting.id}/forms/confirmation"

    click_link '登録'

    current_path.should == '/hq/meetings/scheduling'
  end
end

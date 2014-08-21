# encoding:utf-8
require "spec_helper"

describe "レッスン可能な時間を設定する" do
  context "チューターとしてログインしている" do
    before(:each) do
      tutor = FactoryGirl.create(:tutor)
      login_as(tutor)
    end

    it "曜日ごとに時間帯を設定する" do
      visit "/tu/settings/weekday_schedules"
    end

    it "特定の日を授業不可にする"

  end
end

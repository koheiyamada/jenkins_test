# encoding:utf-8
require 'spec_helper'

describe Account::GroupLessonPremium do
  describe ".create" do
    let(:student) {FactoryGirl.create(:student)}
    let(:student2) {FactoryGirl.create(:student, user_name:"student2")}
    let(:tutor) {FactoryGirl.create(:tutor)}
    let(:today) {Date.today}

    before(:each) do
      tutor.anytime_available = true
      @subject = FactoryGirl.create(:subject)
      @t = 1.hour.from_now
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:@subject, students:[student, student2], start_time:@t, units:1)
    end

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::GroupLessonPremium.new(
        owner:tutor,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_money_received: 10000,
        lesson: @lesson
      ).should be_valid
    end

    #it "生徒が一人の授業だと適用できない" do
    #  single_lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:@subject, students:[student], start_time:1.hour.since(@t), units:1)
    #  expect {
    #    Account::GroupLessonPremium.create!(lesson:lesson, student:student)
    #  }.to raise_error
    #end
    #
    #it "同時レッスン割引を追加する" do
    #  expect {
    #    Account::GroupLessonPremium.create!(lesson:@lesson)
    #  }.to change(Account::GroupLessonPremium, :count).by(1)
    #end
    #
    #describe "支払制限" do
    #  it "同じ授業には一回しか適用できない" do
    #    expect {
    #      Account::GroupLessonPremium.create!(lesson:@lesson)
    #    }.to change(Account::GroupLessonPremium, :count).by(1)
    #    expect {
    #      Account::GroupLessonPremium.create!(lesson:@lesson)
    #    }.to raise_error
    #  end
    #end
    #
    #it "決済は授業日の翌月の１日" do
    #  month = @lesson.start_time
    #  entry = Account::GroupLessonPremium.create!(lesson:@lesson)
    #  entry.settlement_date.should == 1.month.since(month).beginning_of_month.to_date
    #end
    #
    #context "ベーシックレッスンの場合" do
    #  it "決済月はレッスン日の前月"
    #end
    #
    #context "オプションレッスンの場合" do
    #  it "決済日はレッスン日と同じ月"
    #end
    #
    #it "支払人は本部" do
    #  entry = Account::GroupLessonPremium.create!(lesson:@lesson)
    #  entry.payer.should == Headquarter.instance
    #end
    #
    #it "金額はレッスン料金と同じ" do
    #  entry = Account::GroupLessonPremium.create!(lesson:@lesson)
    #  entry.amount.should == @lesson.group_lesson_premium
    #end
  end
end

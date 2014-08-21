# encoding:utf-8
require 'spec_helper'

describe Account::GroupLessonDiscount do
  describe ".create" do
    let(:student) {FactoryGirl.create(:student)}
    let(:student2) {FactoryGirl.create(:student, user_name:"student2")}
    let(:tutor) {FactoryGirl.create(:tutor)}
    let(:today) {Date.today}

    before(:each) do
      @subject = FactoryGirl.create(:subject)
      @t = 1.hour.from_now
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:@subject, students:[student, student2], start_time:@t, units:1)
    end

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::GroupLessonDiscount.new(
        owner:student,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_money_received: 10000,
        lesson: @lesson
      ).should be_valid
    end

    #it "生徒が一人の授業だと適用できない" do
    #  single_lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:@subject, students:[student], start_time:1.hour.since(@t), units:1)
    #  Account::GroupLessonDiscount.new(
    #    owner:student,
    #    year: today.year,
    #    month: today.month,
    #    client:Headquarter.instance,
    #    amount_of_money_received: 10000,
    #    lesson: single_lesson
    #  ).should be_invalid
    #end
    #
    #describe "支払制限" do
    #  it "同じ授業には一回しか適用できない" do
    #    expect {
    #      Account::GroupLessonDiscount.new(
    #        owner:student,
    #        year: today.year,
    #        month: today.month,
    #        client:Headquarter.instance,
    #        amount_of_money_received: 10000,
    #        lesson: @lesson
    #      ).should be_valid
    #    }.to change(Account::GroupLessonDiscount, :count).by(1)
    #    expect {
    #      Account::GroupLessonDiscount.new(
    #        owner:student,
    #        year: today.year,
    #        month: today.month,
    #        client:Headquarter.instance,
    #        amount_of_money_received: 10000,
    #        lesson: @lesson
    #      ).should be_valid
    #    }.to raise_error
    #  end
    #
    #  it "違うアカウントについては適用できる" do
    #    lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:@subject, students:[student, student2])
    #    expect {
    #      Account::GroupLessonDiscount.new(
    #        owner:student,
    #        year: today.year,
    #        month: today.month,
    #        client:Headquarter.instance,
    #        amount_of_money_received: 10000,
    #        lesson: @lesson
    #      ).should be_valid
    #    }.to change(Account::GroupLessonDiscount, :count).by(1)
    #    expect {
    #      Account::GroupLessonDiscount.new(
    #        owner:student2,
    #        year: today.year,
    #        month: today.month,
    #        client:Headquarter.instance,
    #        amount_of_money_received: 10000,
    #        lesson: @lesson
    #      ).should be_valid
    #    }.to change(Account::GroupLessonDiscount, :count).by(1)
    #  end
    #end

    # context "ベーシックレッスンの場合" do
    #   it "決済月はレッスン日の前月"
    # end
    #
    # context "オプションレッスンの場合" do
    #   it "決済日はレッスン日と同じ月"
    # end
  end
end

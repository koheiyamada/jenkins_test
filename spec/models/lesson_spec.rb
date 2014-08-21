# coding:utf-8
require 'spec_helper'

describe Lesson do

  let(:subject) {FactoryGirl.create(:subject)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student])}

  describe "journalize_for_month!" do
    context "オプションレッスンがある" do
      context "オプションレッスンは確定済みでない" do
        it "集計に影響しない" do
          expect {
            Lesson.journalize_for_month!(lesson.settlement_year, lesson.settlement_month)
          }.not_to change(Account::OptionalLessonFee, :count)
        end
      end

      context "オプションレッスンは確定済みである" do
        before(:each) do
          lesson.establish
        end

        it "オプションレッスン受講料が２つ発生する" do
          expect {
            Lesson.journalize_for_month!(lesson.settlement_year, lesson.settlement_month)
          }.to change(Account::OptionalLessonFee, :count).by(1)
        end

        it "別の月の集計には影響しない" do
          expect {
            m = lesson.payment_month.next_month
            Lesson.journalize_for_month!(m.year, m.month)
          }.not_to change(Account::OptionalLessonFee, :count)
        end

        it "繰り返し実行しても数は変わらない" do
          expect {
            Lesson.journalize_for_month!(lesson.settlement_year, lesson.settlement_month)
          }.to change(Account::OptionalLessonFee, :count).by(1)
          expect {
            Lesson.journalize_for_month!(lesson.settlement_year, lesson.settlement_month)
          }.not_to change(Account::OptionalLessonFee, :count)
        end
      end
    end
  end

  describe '.accounting_incomplete' do
    before(:each) do
      lesson.accept!
      lesson.update_column :accounting_status, 'incomplete'

      @lesson2 = FactoryGirl.create(:optional_lesson, tutor:tutor, students: [student], start_time: 2.hours.since(lesson.start_time))
      Lesson.count.should == 2
    end

    it '会計処理が完全に完了していないレッスンを返す' do
      Lesson.accounting_incomplete.should have(1).item
      Lesson.accounting_incomplete.all?{|lesson| lesson.accounting_status == 'incomplete'}.should be_true
    end
  end

  describe '.sweep_ignored_requests' do
    it '開始予定時刻10分前を過ぎても申込中状態のレッスンを拒否扱いにする' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      Time.stub(:now){9.minutes.ago(lesson.start_time)}

      expect {
        Lesson.sweep_ignored_requests
      }.to change{Lesson.find(lesson.id).rejected?}.from(false).to(true)
    end

    it '開始予定時刻10分前を過ぎても申込中でなければそのまま' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      lesson.accept.should be_valid
      Time.stub(:now){9.minutes.ago(lesson.start_time)}

      expect {
        Lesson.sweep_ignored_requests
      }.not_to change{Lesson.find(lesson.id).accepted?}.from(true)
    end

    it '開始予定時刻11分前だと何もしない' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      Time.stub(:now){11.minutes.ago(lesson.start_time)}

      expect {
        Lesson.sweep_ignored_requests
      }.not_to change{Lesson.find(lesson.id).status}
    end
  end

  describe '.reset_door_keeping_jobs' do
    before(:each) do
      lesson.accept!
    end

    it 'lessonのreset_door_keeperが呼ばれる' do
      Lesson.any_instance.should_receive(:reset_door_keeper)
      Lesson.reset_door_keeping_jobs
    end
  end
end

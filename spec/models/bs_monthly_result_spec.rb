# coding:utf-8
require 'spec_helper'

describe BsMonthlyResult do
  let(:month) {1.month.from_now.change(day: SystemSettings.cutoff_date)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student, organization: bs)}
  subject  {FactoryGirl.create(:bs_monthly_result, organization: bs, year: month.year, month: month.month)}

  describe 'create' do
    it '未計算状態になる' do
      d = Date.today
      bs_monthly_result = FactoryGirl.create(:bs_monthly_result, year: d.year, month: d.month)
      bs_monthly_result.should_not be_calculated
    end
  end

  describe '#calculate' do

    it '計算済み状態になる' do
      expect {
        subject.calculate
      }.to change{subject.calculated?}.from(false).to(true)
    end

    context "オプションレッスンがある" do
      before(:each) do
        @t = 1.month.from_now.change(day:20)
        #Lesson.any_instance.stub(:cs_sheets_collected?).and_return(true)
      end

      context 'チューターが仮登録の場合' do
        before(:each) do
          Tutor.any_instance.stub(:regular?).and_return(false)
          @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
          @lesson.establish
          @lesson.journalize!
          Account::JournalEntry.count.should be > 0
          @lesson.fee(student).should be > 0
        end

        it '売上には加算される' do
          expect{
            subject.calculate
          }.to change{subject.lesson_sales_amount}.by(@lesson.fee(student))
        end

        it '本登録チューター売上には反映されない' do
          expect{
            subject.calculate
          }.not_to change{subject.lesson_sales_of_regular_tutors}
        end

        it 'BSの取り分はゼロ' do
          expect{
            subject.calculate
          }.not_to change{subject.bs_share_of_lesson_sales}
        end
      end

      context 'チューターが本登録の場合' do
        before(:each) do
          Tutor.any_instance.stub(:regular?).and_return(true)
          @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:@t, units:1)
          @lesson.establish
          @lesson.journalize!
          Account::JournalEntry.count.should be > 0
          @lesson.fee(student).should be > 0
        end

        it '来月の売上に加算される' do
          expect{
            subject.calculate
          }.to change{subject.lesson_sales_amount}.by(@lesson.fee(student))
        end

        it '本登録チューター売上にも加算される' do
          expect{
            subject.calculate
          }.to change{subject.lesson_sales_of_regular_tutors}.from(0).to(@lesson.fee(student))
        end

        it 'BSの取り分は25%' do
          expect{
            subject.calculate
          }.to change{subject.bs_share_of_lesson_sales}.from(0).to(@lesson.fee(student) / 4)
        end
      end
    end
  end
end

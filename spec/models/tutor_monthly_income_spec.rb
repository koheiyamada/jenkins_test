# coding:utf-8
require 'spec_helper'

describe TutorMonthlyIncome do
  let(:tutor){FactoryGirl.create(:tutor)}
  let(:student){FactoryGirl.create(:student)}

  describe '.create' do
    it '金額の初期値はゼロ' do
      d = Date.today
      year = d.year
      month = d.month

      income = TutorMonthlyIncome.new(tutor: tutor, year: year, month: month)
      income.current_amount.should == 0
      income.expected_amount.should == 0
    end
  end

  describe '#calculate' do
    context 'レッスン予定がある' do
      before(:each) do
        d = 1.month.from_now.change(day: SystemSettings.cutoff_date)
        @year = d.year
        @month = d.month
        start_time = d.beginning_of_day

        @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student], start_time: start_time)
        @lesson.accept
        Time.stub(:now){2.hour.since start_time}
      end

      it '見込み金額が増える' do
        income = TutorMonthlyIncome.new(tutor: tutor, year: @year, month: @month)
        expect {
          income.calculate.errors.should be_empty
        }.to change{income.expected_amount}.from(0).to(@lesson.tutor_base_wage)
      end

      context 'レッスンの料金支払いが未確定している場合' do
        it '見込み金額には反映される' do
          income = TutorMonthlyIncome.new(tutor: tutor, year: @year, month: @month)
          expect {
            income.calculate.errors.should be_empty
          }.to change{income.expected_amount}.from(0).to(@lesson.tutor_base_wage)
        end

        it '現在の金額には反映されない' do
          income = TutorMonthlyIncome.new(tutor: tutor, year: @year, month: @month)
          expect {
            income.calculate.errors.should be_empty
          }.not_to change{income.current_amount}.from(0)
        end
      end

      context 'レッスンの料金支払いが確定している場合' do
        before(:each) do
          @lesson.establish
        end

        it '見込み金額には反映される' do
          income = TutorMonthlyIncome.new(tutor: tutor, year: @year, month: @month)
          expect {
            income.calculate.errors.should be_empty
          }.to change{income.expected_amount}.from(0).to(@lesson.tutor_base_wage)
        end

        it '現在の金額にも反映される' do
          income = TutorMonthlyIncome.new(tutor: tutor, year: @year, month: @month)
          expect {
            income.calculate.errors.should be_empty
          }.to change{income.current_amount}.from(0).to(@lesson.tutor_base_wage)
        end
      end
    end
  end
end

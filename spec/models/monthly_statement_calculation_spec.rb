# coding:utf-8
require 'spec_helper'

describe MonthlyStatementCalculation do
  subject {FactoryGirl.create(:monthly_statement_calculation,
                              year: Date.today.year, month: Date.today.month)}

  describe '#execute' do
    it '#calculate_for_studentsを呼ぶ' do
      subject.should_receive(:calculate_for_students)
      subject.execute
    end

    it '#calculate_for_tutorsを呼ぶ' do
      subject.should_receive(:calculate_for_tutors)
      subject.execute
    end

    it '#calculate_for_bssを呼ぶ' do
      subject.should_receive(:calculate_for_bss)
      subject.execute
    end

    it '#calculate_for_headquarterを呼ぶ' do
      subject.should_receive(:calculate_for_headquarter)
      subject.execute
    end
  end
end

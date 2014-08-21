# coding:utf-8
require "spec_helper"

describe StudentMailer do
  let(:student){FactoryGirl.create(:active_student)}
  let(:today){Date.today}
  let(:tutor){FactoryGirl.create(:tutor)}

  describe 'monthly_payment_fixed' do
    it 'makes mail object' do
      monthly_statement = student.monthly_statement_of_month(today.year, today.month)
      mail = StudentMailer.monthly_payment_fixed(student, monthly_statement)
      mail.subject.should == "[AID Tutoring System]#{today.month}月分ご請求金額のご連絡"
    end
  end

  describe 'lesson_skipped_because_of_tutor' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept!
    end

    it 'makes mail object' do
      mail = StudentMailer.lesson_skipped_because_of_tutor(student, @lesson)
      mail.subject.should == '[AID Tutoring System]チューターの都合によりレッスンが行われませんでした'
    end
  end

  describe 'lesson_skipped_because_of_student' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept!
    end

    it 'makes mail object' do
      mail = StudentMailer.lesson_skipped_because_of_student(student, @lesson)
      mail.subject.should == '[AID Tutoring System]受講者様のご都合によりレッスンが不開催となりました'
    end
  end

end

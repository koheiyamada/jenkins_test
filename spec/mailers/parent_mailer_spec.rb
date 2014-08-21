# coding:utf-8
require "spec_helper"

describe ParentMailer do
  let(:parent){FactoryGirl.create(:active_parent)}
  let(:today){Date.today}
  let(:student){FactoryGirl.create(:active_student, parent: parent)}
  let(:tutor){FactoryGirl.create(:tutor)}

  describe 'monthly_payment_fixed' do
    it 'makes mail object' do
      monthly_statement = parent.monthly_statement_of_month(today.year, today.month)
      mail = ParentMailer.monthly_payment_fixed(parent, monthly_statement)
      mail.subject.should == "[AID Tutoring System]#{today.month}月分ご請求金額のご連絡"
    end
  end

  describe 'lesson_skipped_because_of_tutor' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept!
    end

    it 'makes mail object' do
      mail = ParentMailer.lesson_skipped_because_of_tutor(parent, student, @lesson)
      mail.subject.should == '[AID Tutoring System]チューターの都合によりレッスンが行われませんでした'
    end
  end

  describe 'lesson_skipped_because_of_student' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept!
    end

    it 'makes mail object' do
      mail = ParentMailer.lesson_skipped_because_of_student(parent, student, @lesson)
      mail.subject.should == '[AID Tutoring System]受講者様のご都合によりレッスンが不開催となりました'
    end
  end

end

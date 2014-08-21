# coding: utf-8

require 'spec_helper'

describe TrialLesson do
  let(:tutor) {FactoryGirl.create :tutor}
  let(:student) {FactoryGirl.create :active_student}
  subject {FactoryGirl.create(:trial_lesson, tutor: tutor, students: [student])}

  describe '.create' do
    it '受講者に支払能力がなくても作成できる' do
      student.stub(:afford_to_take_lesson_from?){false}

      lesson = TrialLesson.create(start_time: 2.hours.from_now, units: 1) do |l|
        l.tutor = tutor
        l.students = [student]
      end
      lesson.should be_persisted
    end
  end

  describe '#fix' do
    it '状態がacceptedになる' do
      expect {
        subject.fix!
      }.to change{subject.accepted?}.from(false).to(true)
    end

    it 'established?がtrueを返すようになる' do
      expect {
        subject.fix!
      }.not_to change{subject.established?}.from(false)
    end
  end

  describe '#establish' do
    it '状態は変わらない' do
      expect {
        subject.establish
      }.not_to change{subject.established?}.from(false)
    end
  end

  describe '#journalize!' do
    before(:each) do
      subject.fix!
    end

    it '料金、賃金は発生しない' do
      expect{
        subject.journalize!
      }.not_to change(Account::JournalEntry, :count)
    end

    it '記録も残らない' do
      expect {
        subject.journalize!
      }.not_to change{subject.journalized?}.from(false)
    end
  end

end

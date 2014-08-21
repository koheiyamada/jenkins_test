# coding:utf-8
require 'spec_helper'

describe LessonCharge do
  let(:tutor) {FactoryGirl.create :tutor}
  let(:student) {FactoryGirl.create :student}
  let(:student2) {FactoryGirl.create :student}
  let(:lesson) {FactoryGirl.create :optional_lesson, tutor: tutor, students: [student]}
  let(:shared_lesson) {FactoryGirl.create :shared_optional_lesson, tutor: tutor, students: [student, student2]}
  let(:lesson_student) {lesson.student(student)}

  subject {FactoryGirl.create(:lesson_charge, fee: 1000, lesson_student: lesson_student)}

  describe 'creation' do
    it '料金と受講者があればOK' do
      charge = FactoryGirl.build(:lesson_charge, fee: 1000, lesson_student: lesson_student)
      charge.save
      charge.should be_valid
    end
  end

  describe '#organization' do
    it '受講者の所属組織を返す' do
      student.organization.should be_present
      subject.organization.should == student.organization
    end
  end

  describe '#contains_bs_share?' do
    context 'チューターが仮登録' do
      it 'falseを返す' do
        Tutor.any_instance.stub(:regular?).and_return(false)
        subject.contains_bs_share?.should be_false
      end
    end

    context 'チューターが本登録' do
      it 'trueを返す' do
        Tutor.any_instance.stub(:regular?).and_return(true)
        subject.contains_bs_share?.should be_true
      end
    end
  end

  describe '#journalize' do
    it 'Account::JounalEntryが１つ増える' do
      expect {
        subject.journalize
      }.to change(Account::JournalEntry, :count).by(1)
    end

    it '支払者は受講者' do
      journal_entry = subject.journalize
      journal_entry.owner.should == student
    end

    it '支払金額は「税抜き」の料金に等しい' do
      journal_entry = subject.journalize
      journal_entry.amount_of_payment.should == subject.fee
    end

    it '受取金額はゼロ' do
      journal_entry = subject.journalize
      journal_entry.amount_of_money_received.should == 0
    end

    it '#journalized?がtrueになる' do
      expect {
        subject.journalize.should be_persisted
      }.to change{subject.journalized?}.from(false).to(true)
    end
  end
end

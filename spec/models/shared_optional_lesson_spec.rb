# coding:utf-8
require 'spec_helper'

describe SharedOptionalLesson do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:tutor2) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:student2) {FactoryGirl.create(:student)}

  describe '登録する' do
    let(:subject) {FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now)}

    it '同時レッスンである' do
      subject.should be_shared_lesson
    end

    it 'レッスンは生徒を二人まで持てる' do
      subject.max_student_count.should == 2
    end
  end

  describe '#add_student 参加' do
    let(:subject) {FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now)}

    it '別の生徒であれば誰でも参加できる' do
      expect {
        subject.add_student(student2)
      }.to change{subject.students.count}.by(1)
    end

    it 'すでに参加している生徒を追加しても意味は無い' do
      expect {
        subject.add_student(student)
      }.not_to change{subject.students.count}
    end

    context '満員の場合' do
      before(:each) do
        subject.stub(:full?){true}
      end

      it '満席だと参加できない' do
        expect {
          subject.add_student(student2).should be_false
        }.not_to change{Lesson.find(subject.id).lesson_students.count}
      end

      it 'errors[:students]にエラーがセットされる' do
        subject.add_student(student2).should be_false
        subject.errors[:students].should be_present
      end
    end
  end

  describe '料金' do

  end

  describe '#cancel_lesson キャンセルする' do
    let(:subject) {
      FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student, student2], start_time:2.hour.from_now)
    }

    it 'LessonCancellationが増える' do
      expect {
        student.cancel_lesson(subject).should be_persisted
      }.to change(LessonCancellation, :count).by(1)
    end

    it '生徒が一人になる' do
      expect {
        student.cancel_lesson(subject).should be_persisted
      }.to change{LessonStudent.where(lesson_id:subject.id).remaining.count}.from(2).to(1)
    end

    it 'レッスンの状態は変わらない' do
      expect {
        student.cancel_lesson(subject).should be_persisted
      }.not_to change{subject.reload.status}
    end

    it '同時レッスンでなくなる' do
      expect {
        student.cancel_lesson(subject).should be_persisted
      }.to change{subject.group_lesson?}.from(true).to(false)
    end

    it '同時レッスン割引がなくなる' do
      expect {
        student.cancel_lesson(subject).should be_persisted
      }.to change{subject.total_fee(student)}.from(subject.fee(student) - subject.group_lesson_discount(student)).to(subject.fee(student))
    end
  end

  describe '日程変更' do
    let(:subject) {
      FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student, student2], start_time:2.hour.from_now)
    }
    before(:each) do
      subject.accept!
    end

    it '日程変更はできない' do
      subject.start_time = 1.day.since subject.start_time
      subject.save.should be_false
      subject.errors.full_messages.should == ['同時レッスンでは、日時の変更はできません。']
    end
  end

  describe '#style' do
    let(:subject) {FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now)}

    it '開始されたレッスンで参加者が1人だと通常レッスンになる' do
      subject.stub(:started?){true}
      subject.stub(:group_lesson?){false}

      subject.style.should == :single
    end
  end
end

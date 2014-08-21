# coding:utf-8
require 'spec_helper'

describe FriendsOptionalLesson do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:tutor2) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:student2) {FactoryGirl.create(:student)}

  describe '登録する' do
    let(:subject) {FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now)}

    it 'お友達レッスンである' do
      subject.should be_friends_lesson
    end

    it "レッスンは生徒を二人まで持てる" do
      subject.max_student_count.should == 2
    end
  end

  describe '招待する' do
    let(:subject) {
      FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now)
    }

    it '招待した人がfriendになる' do
      invitation = subject.invite!(student2)
      invitation.student.should == student2
    end

    it 'LessonInvitationが増える' do
      expect {subject.invite!(student2)}.to change(LessonInvitation, :count).by(1)
    end
  end

  describe 'inviattion_accepted 招待を受ける' do
    let(:subject) {FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student])}

    before(:each) do
      subject.invite!(student2)
    end

    it 'レッスンの生徒が増える' do
      expect {
        subject.invitation_accepted(student2)
      }.to change{subject.students.count}.from(1).to(2)
    end

    it '招待承諾済になる' do
      expect {
        subject.invitation_accepted(student2)
      }.to change{subject.lesson_invitation.reload.accepted?}.from(false).to(true)
    end
  end

  describe '招待を断る' do
    let(:subject) {FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student])}

    before(:each) do
      subject.accept
      subject.invite!(student2)
    end

    it '招待中の人リストが１つ減る' do
      expect {
        subject.invitation_rejected(student2)
      }.to change{subject.no_reply_invitees.count}.by(-1)
    end
  end


  describe '料金' do
    pending
  end

  describe 'キャンセルする' do
    #
    # 動作としてはSharedOptionalLessonと変わらない
    #

    let(:subject) {FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student, student2])}

    it '生徒が一人になる' do
      expect {
        student.cancel_lesson(subject).should be_true
      }.to change{LessonStudent.where(lesson_id:subject.id).remaining.count}.from(2).to(1)
    end

    it 'レッスンの状態は変わらない' do
      expect {
        student.cancel_lesson(subject).should be_true
      }.not_to change{subject.reload.status}
    end

    it '同時レッスンでなくなる' do
      expect {
        student.cancel_lesson(subject).should be_true
      }.to change{subject.group_lesson?}.from(true).to(false)
    end

    it '同時レッスン割引がなくなる' do
      expect {
        student.cancel_lesson(subject).should be_true
      }.to change{subject.total_fee(student)}.from(subject.fee(student) - subject.group_lesson_discount(student)).to(subject.fee(student))
    end
  end

  describe '日程変更' do
    let(:subject) {
      FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student, student2], start_time:2.hour.from_now)
    }
    before(:each) do
      subject.accept!
    end

    it '日程変更はできない' do
      subject.start_time = 1.day.since subject.start_time
      subject.save.should be_false
      subject.errors.full_messages.should == ['友達レッスンでは、日時の変更はできません。']
    end
  end

  describe '#style' do
    let(:subject) {FactoryGirl.create(:friends_optional_lesson, tutor:tutor, students:[student, student2], start_time:1.hour.from_now)}

    it '開始されたレッスンで参加者が1人だと通常レッスンになる' do
      subject.stub(:started?){true}
      subject.stub(:group_lesson?){false}

      subject.style.should == :single
    end
  end
end

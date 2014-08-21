# encoding:utf-8
require 'spec_helper'

describe Student do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:hq_user) {FactoryGirl.create(:hq_user)}
  subject {FactoryGirl.create(:active_student)}

  describe "#leave 退会する" do

    it "非アクティブ化する" do
      expect {
        subject.leave!
      }.to change{Student.find(subject.id).active?}.from(true).to(false)
    end

    it 'on_leavingが呼ばれる' do
      subject.should_receive(:on_leaving)
      subject.leave!
    end

    context "未実施のオプションレッスンがある場合" do
      before(:each) do
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[subject], start_time:61.minutes.from_now, units:1)
        @lesson.accept!
      end

      it "退会できる" do
        subject.leave.should be_true
      end

      it "レッスンはキャンセルされる" do
        expect {
          subject.leave
        }.to change{@lesson.reload.cancelled?}.from(false).to(true)
      end
    end

    context "キャンセル期間外のオプションレッスンがある場合でも" do
      before(:each) do
        tutor = FactoryGirl.create(:tutor)
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[subject], start_time:16.minutes.from_now, units:1)
        @lesson.accept!
        Time.stub(:now){5.minutes.ago(@lesson.start_time)}
      end

      it "退会できる" do
        subject.leave.should be_true
      end

      it "レッスンはキャンセルされる" do
        expect {
          subject.leave
        }.to change{@lesson.reload.cancelled?}.from(false).to(true)
      end
    end

    context '現在レッスン中の場合' do
      before(:each) do
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[subject], start_time:61.minutes.from_now, units:1)
        @lesson.accept!
        Time.stub(:now){10.minutes.since(@lesson.start_time)}
      end

      it '退会できない' do
        subject.leave.should be_false
      end

      it 'activeフィールドのエラーを持つ' do
        subject.leave
        subject.errors[:active].should have(1).item
      end
    end

    context '現在面談中の場合' do
      before(:each) do
        subject.stub(:in_meeting?){true}
      end

      it '退会できない' do
        subject.leave.should_not be_true
      end

      it 'activeフィールドのエラーを持つ' do
        subject.leave
        subject.errors[:active].should == ['面談中のため退会処理を実行できません。']
      end
    end

    context '面談予定がある場合' do
      before(:each) do
        meeting = FactoryGirl.create(:meeting, members: [hq_user, subject], datetime: 1.hour.from_now)
        subject.meetings.should have(1).item
      end

      it 'それらは削除される' do
        expect {
          subject.leave.should be_true
        }.to change(Meeting, :count).by(-1)
      end
    end

    context 'ベーシックレッスンを受講している場合' do
      before(:each) do
        now = Time.current
        schedule = BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
        @basic_lesson_info = FactoryGirl.create(:basic_lesson_info,
                                                tutor:tutor,
                                                students:[subject],
                                                schedules:[schedule])
      end

      it '自動延長がオフになる' do
        expect {
          subject.leave.should be_true
        }.to change{BasicLessonInfo.find(@basic_lesson_info.id).auto_extension}.from(true).to(false)
      end
    end
  end
end

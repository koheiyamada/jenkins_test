# coding:utf-8
require "spec_helper"

describe TutorMailer do
  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:1.hour.from_now, units:1)}

  describe "lesson_request_arrived" do
    let(:mail) { TutorMailer.lesson_request_arrived(lesson) }

    it "renders the headers" do
      mail.subject.should eq("Lesson request arrived")
      mail.to.should eq([lesson.tutor.email])
      mail.from.should eq(["noreply@aidnet.jp"])
    end

    it "renders the body" do
      mail.body.encoded.should match(lesson.students.first.nickname)
    end
  end

  describe "optional_lesson_requested" do
    subject {TutorMailer.optional_lesson_requested(lesson)}

    it "生徒の呼称を含む" do
      subject.body.encoded.should match(student.nickname)
    end
  end

  describe "lesson_coming_notification" do
    subject {TutorMailer.lesson_coming_notification(lesson)}

    it "生徒の呼称を含む" do
      subject.body.encoded.should match("レッスン開始時刻が近づいています。")
    end
  end

  describe 'lesson_skipped_because_of_tutor' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept!
    end

    it 'makes mail object' do
      mail = TutorMailer.lesson_skipped_because_of_tutor(tutor, @lesson)
      mail.subject.should == '[AID Tutoring System]チューターの都合によりレッスンが行われませんでした'
    end
  end

  describe 'lesson_skipped_because_of_student' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept!
    end

    it 'makes mail object' do
      mail = TutorMailer.lesson_skipped_because_of_student(tutor, @lesson)
      mail.subject.should == '[AID Tutoring System]受講者様のご都合によりレッスンが不開催となりました'
    end
  end

  describe 'tutor_created' do
    it 'id, passwordを含む' do
      tutor.password.should be_present
      mail = TutorMailer.tutor_created(tutor, tutor.password)
      mail.body.should include('パスワード: password')
    end
  end
end

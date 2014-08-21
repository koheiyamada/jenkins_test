# coding:utf-8
require 'spec_helper'

describe LessonReport do
  let(:tutor) { FactoryGirl.create(:tutor) }
  let(:student) { FactoryGirl.create(:student) }
  let(:student2) { FactoryGirl.create(:student) }
  let(:subject) { FactoryGirl.create(:subject) }
  let(:lesson) {
    l = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time: 1.hour.from_now, units:1)
    l.start!(1.hour.ago(Time.now))
    l.done!(15.minutes.ago(Time.now))
    l
  }
  let(:report) {
    LessonReport.create(lesson: lesson, student: student, author: lesson.tutor, subject: subject) do |report|
      report.lesson_content = "English"
      report.homework_result = "good"
      report.understanding = "He is great!"
      report.word_to_student = "You are doing very well."
    end
  }

  it '同じレッスンについて同じ人が複数作ることはできない' do
    FactoryGirl.create(:lesson_report, lesson: lesson, student: student, author: lesson.tutor, subject: subject,
                       lesson_content: 'English', homework_result: 'good', understanding: 'He is great!', word_to_student: 'You are doing very well.')
    report = FactoryGirl.build(:lesson_report, lesson: lesson, student: student, author: lesson.tutor, subject: subject,
                               lesson_content: 'English', homework_result: 'good', understanding: 'He is great!', word_to_student: 'You are doing very well.')
    report.should_not be_valid
    report.errors.full_messages.should == ['このレッスンのレッスンレポートは提出済みです。']
  end

  describe "作成する" do
    before(:each) do
      @report = LessonReport.new(lesson: lesson, student: student, author: lesson.tutor, subject: subject) do |report|
        report.lesson_content = "English"
        report.homework_result = "good"
        report.understanding = "He is great!"
        report.word_to_student = "You are doing very well."
      end
    end

    it "レッスン内容、前回の宿題状況、理解の程度、生徒に一言の入力が必須" do
      @report.should be_valid
    end
  end

  context '保存後' do
    it "開始時刻を持つ" do
      report.started_at.should be_present
    end

    it "終了時刻を持つ" do
      report.ended_at.should be_present
    end

    it "チューターを持つ" do
      report.tutor.should be_present
    end

    it "日にちを持つ" do
      report.date.should be_present
    end

    it "科目をもつ" do
      report.subject.should be_present
    end


    it "生徒を持つ" do
      report.student.should be_present
    end

    it "学年を持つ" do
      report.grade.should be_present
    end

    it "授業の種類を持つ" do
      report.should respond_to(:basic_lesson?)
      report.should respond_to(:optional_lesson?)
    end

    it "アップロードしたデータの有無を返す" do
      report.should respond_to(:has_attached_files?)
    end

    it "特記事項がある" do
      report.should respond_to(:note)
    end

    it "テキストの使用箇所記入欄がある" do
      report.should respond_to(:textbook_usage)
    end

    it 'レポートは１受講者当たり１つまで' do
      report.should be_persisted
      @report = LessonReport.new(lesson: lesson, student: student, author: lesson.tutor, subject: subject) do |report|
        report.lesson_content = "English"
        report.homework_result = "good"
        report.understanding = "He is great!"
        report.word_to_student = "You are doing very well."
      end
      @report.should_not be_valid


    end

    it 'レポートは１受講者当たり１つまで' do
      report.should be_persisted
      @report = LessonReport.new(lesson: lesson, student: student, author: lesson.tutor, subject: subject) do |report|
        report.lesson_content = "English"
        report.homework_result = "good"
        report.understanding = "He is great!"
        report.word_to_student = "You are doing very well."
      end
      @report.should_not be_valid

      @report.student = student2
      @report.should be_valid
    end
  end

end

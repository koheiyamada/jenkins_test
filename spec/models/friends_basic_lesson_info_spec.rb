# coding:utf-8
require 'spec_helper'

describe FriendsBasicLessonInfo do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}
  let(:student2) {FactoryGirl.create(:student)}
  let(:now) {Time.current}
  subject {FactoryGirl.create(:friends_basic_lesson_info,
                              tutor:tutor,
                              students:[student, student2],
                              schedules:[schedule])}

  def schedule
    BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
  end

  def schedule2
    BasicLessonWeekdaySchedule.new(wday:(now.wday + 1) % 6, start_time:now, units:1)
  end

  describe '作成する' do
    it '受講者二人で登録できる' do
      info = FactoryGirl.create(:friends_basic_lesson_info,
                                tutor:tutor,
                                students:[student, student2],
                                schedules:[schedule])
      info.should_not be_shared_lesson
      info.should be_friends_lesson
    end

    it '受講者ひとりと参加候補者ひとりの指定で作成できる' do
      info = FactoryGirl.create(:friends_basic_lesson_info,
                                tutor:tutor,
                                students:[student],
                                schedules:[schedule],
                                possible_students:[student2])
      info.should be_friends_lesson
      info.should_not be_shared_lesson
    end
  end

  context '参加確定１人のお友達レッスンの場合' do
    let(:info) {FactoryGirl.create(:friends_basic_lesson_info,
                                   tutor:tutor,
                                   students:[student],
                                   schedules:[schedule],
                                   possible_students:[student2])}
    before(:each) do
      info.activate!
    end

    it 'possible_studentsにない受講者は参加できない' do
      student3 = FactoryGirl.create(:student)
      expect {
        info.students << student3
      }.to raise_error
    end

    it 'possible_studentsにある生徒は参加できる' do
      expect {
        info.students << student2
      }.to change{BasicLessonInfo.find(info.id).students.count}.from(1).to(2)
    end
  end

  describe 'レッスンデータを作成する' do
    it '作成されたデータは友達レッスン' do
      lessons = subject.supply_lessons
      lessons.should_not be_empty
      lessons.each do |lesson|
        lesson.should be_friends_lesson
      end
      lessons.each do |lesson|
        lesson.style.should eq(:friends)
      end
    end
  end

end

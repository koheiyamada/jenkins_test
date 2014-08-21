# encoding:utf-8
require "spec_helper"

describe "Lesson cancellation" do
  let(:student) {FactoryGirl.create(:active_student)}
  let(:student2) {FactoryGirl.create(:active_student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:lesson) {FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student, student2])}

  before(:each) do
    login_as student
  end

  describe 'キャンセルしない' do
    before(:each) do
      lesson.accept.should be_valid
    end

    it 'レッスンページを開いてもキャンセルの文字はない' do
      visit "/st/lessons/#{lesson.id}"

      page.should_not have_content 'キャンセル'
    end

    it 'レッスン時間になると入室ボタンがある' do
      Time.stub(:now).and_return(4.minutes.ago(lesson.start_time))

      visit "/st/lessons/#{lesson.id}"
      page.should have_css("a[href='#{room_st_lesson_path(lesson)}']")
    end
  end

  describe '生徒一人がキャンセルする' do
    before(:each) do
      lesson_cancel = student.cancel_lesson lesson
      lesson_cancel.should be_persisted
    end

    it 'レッスンページを開くとキャンセル' do
      visit "/st/lessons/#{lesson.id}"

      page.should have_content 'キャンセル'
    end

    it 'レッスン時間になっても入室ボタンが出ない' do
      Time.stub(:now){5.minutes.ago lesson.start_time}

      visit "/st/lessons/#{lesson.id}"
      page.should_not have_css("a[href='#{room_st_lesson_path(lesson)}']")
    end
  end
end

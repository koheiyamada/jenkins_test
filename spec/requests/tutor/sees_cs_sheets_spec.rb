# encoding:utf-8
require "spec_helper"

describe "チューターがCSシートを見る" do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}

  context "チューターとしてログインしているとき" do
    before(:each) do
      lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students: [student], start_time: 1.hour.from_now, units:1)
      lesson.student_attended(student)
      cs_sheet = CsSheet.new do |cs|
        cs.lesson = lesson
        cs.author = student
        cs.content = "Hello"
        cs.score = 5
      end
      cs_sheet.save!

      login_as(tutor)
    end

    it '/tu/cs_sheetsを開くとCSシートの一覧を見ることができる' do
      visit '/tu/cs_sheets'
      current_path.should == '/tu/cs_sheets'
      page.should have_selector('.cs_sheets')
    end
  end
end

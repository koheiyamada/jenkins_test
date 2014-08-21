# encoding:utf-8
require "spec_helper"

describe "お友達レッスンの登録" do
  let(:student) {FactoryGirl.create(:active_student)}
  let(:student2) {FactoryGirl.create(:active_student)}
  let(:tutor) {FactoryGirl.create(:tutor)}

  describe '招待された' do
    before(:each) do
      lesson = FactoryGirl.create(:friends_optional_lesson, tutor: tutor, students: [student], start_time: 2.hours.from_now)
      @invitation = lesson.invite(student2)
      @invitation.should be_persisted
      login_as student2
    end

    it '招待されたレッスンが表示される' do
      visit '/st/lessons/invited'

      page.should have_content(tutor.nickname)
    end
  end
end

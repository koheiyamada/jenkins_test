# encoding:utf-8
require 'spec_helper'

describe St::LessonsController do
  disconnect_sunspot

  context "生徒でログイン中" do
    let(:student) {FactoryGirl.create(:active_student)}

    before(:each) do
      sign_in student
    end

    describe "POST :cancel" do
      # キャンセルの方法がLessonCancellationを作成する方法に変わったので無効

      before(:each) do
        t = 1.day.from_now
        tutor = FactoryGirl.create(:tutor)
        tutor.weekday_schedules.create!(wday:t.wday, start_time:t.beginning_of_day, end_time:t.end_of_day)
        tutor.update_available_times
        @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, students:[student], start_time:t)
      end

      it "当該授業をキャンセル状態にする" do
        expect {
          post :cancel, id:@lesson
        }.to change{Lesson.find(@lesson.id).cancelled?}.from(false).to(true)
      end

      it "当該レッスンのページにリダイレクトする" do
        post :cancel, id:@lesson
        response.should redirect_to(st_lesson_path(@lesson))
      end
    end
  end

end

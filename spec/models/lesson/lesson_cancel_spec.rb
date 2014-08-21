# coding:utf-8
require 'spec_helper'

describe Lesson do
  describe '#cancel' do
    let(:tutor){FactoryGirl.create(:tutor)}
    let(:student){FactoryGirl.create(:student)}
    let(:lesson){FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student], start_time: 2.days.from_now)}

    before(:each) do
      lesson.accept
    end

    it '確認メールが削除される' do
      lesson.notifications.should have(3).items
      expect {
        lesson.cancel
      }.to change{lesson.notifications.count}.from(3).to(0)
    end

    it 'チューター入室締切時処理、チューター入室開始時処理が削除される' do
      lesson.jobs.where(queue: Lesson::JobQueue::DOOR_KEEPER).should have(2).items
      expect {
        lesson.cancel
      }.to change{lesson.jobs.where(queue: 'lesson').count}.from(2).to(0)
    end
  end
end
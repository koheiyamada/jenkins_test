# encoding:utf-8
require 'spec_helper'

describe OptionalLesson do
  disconnect_sunspot

  let(:subject) {FactoryGirl.create(:subject)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:tutor2) {FactoryGirl.create(:tutor, user_name:"tutor2")}
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student, organization:bs)}
  let(:student2) {FactoryGirl.create(:student)}

  describe '個人レッスン' do

  end

  describe '同時レッスンだけど一人' do
    before(:each) do
      @lesson = FactoryGirl.create(:shared_optional_lesson, tutor:tutor, students:[student])
      @lesson.establish
    end

    it '個人レッスンと同じ値段' do
      @lesson.fee(student).should == tutor.lesson_fee_for_student(student)
    end
  end

  describe 'お友達レッスン' do

  end

end

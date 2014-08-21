# coding:utf-8

require 'spec_helper'

describe QuestionAnswering do
  let(:student) {FactoryGirl.create(:active_student)}
  let(:question1) {Question.first}

  describe '#answer' do
    let(:q) {Question.first}
    subject {QuestionAnswering.new(student)}

    it 'Answerデータが作成される' do
      ao = q.answer_options.first
      answer = subject.answer(ao)
      answer.should be_persisted
    end

    it '自由記述も追加できる' do
      ao = q.answer_options.first
      desc = 'Hello'
      answer = subject.answer(ao, desc)
      answer.should be_persisted
      answer.custom_answer.value.should == desc
    end
  end
end

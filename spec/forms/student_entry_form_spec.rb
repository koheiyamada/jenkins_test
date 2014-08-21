# coding: utf-8

require 'spec_helper'

describe StudentEntryForm do
  def params
    {
      student: FactoryGirl.attributes_for(:student),
      student_info: FactoryGirl.attributes_for(:student_info),
      address: FactoryGirl.attributes_for(:address),
      has_web_camera: {answer_option_code: 'built_in'},
      how_to_find: {answer_option: 'search_engine_google'},
      reason_to_enroll: {answer_options: {attractive_tutors: {selected: '1'}}}
    }
  end

  describe '#save' do
    it 'アンケートの回答が増える' do
      s = StudentEntryForm.new(params)
      s.valid?
      s.should be_valid
      expect {
        s.save
      }.to change(Answer, :count).by(2)
    end

    context 'アンケートに答えていない場合' do
      it '保存できない' do
        attr = params
        attr[:reason_to_enroll] = {answer_options: {attractive_tutors: {selected: '0'}}}
        s = StudentEntryForm.new(attr)
        s.should_not be_valid
        s.save.should be_false
      end
    end
  end
end
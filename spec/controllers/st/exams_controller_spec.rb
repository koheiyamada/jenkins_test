# encoding:utf-8
require 'spec_helper'

describe St::ExamsController do
  let(:student){FactoryGirl.create(:active_student)}

  describe "#room" do
    context "模試がある" do
      before(:each) do
        sign_in student
        @exam = FactoryGirl.create(:exam)
        student.take_exam!(@exam)
        @exam_params = {subject_id:@exam.subject.id, year:@exam.month.year, month:@exam.month.month}
      end

      it "模試を開始する" do
        student.exam_record_of(@exam).started_at.should be_blank
        get :room, @exam_params
        student.reload.exam_record_of(@exam).started_at.should be_present
      end
    end
  end
end

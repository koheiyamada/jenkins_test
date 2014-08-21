# encoding:utf-8
require 'spec_helper'

describe Bs::Students::ExamsController do
  context "bs_userでログイン中" do
    before(:each) do
      bs_user = FactoryGirl.create(:bs_user)
      @student = FactoryGirl.create(:student, organization:bs_user.organization)
      sign_in(bs_user)
    end

    describe "GET index" do
      it "@studentを割り当てる" do
        get :index, student_id:@student
        assigns(:student).should be_present
      end

      it "生徒のexams_of_this_yearを呼ぶ" do
        student = mock_model(Student).as_null_object
        Student.stub(:find).and_return(student)
        student.should_receive(:exams_of_this_year)

        get :index, student_id:@student
      end
    end
  end
end

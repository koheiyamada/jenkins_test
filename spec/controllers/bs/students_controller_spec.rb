# encoding:utf-8
require 'spec_helper'

describe Bs::StudentsController do
  let(:bs) {FactoryGirl.create(:bs)}
  let(:bs_user) {FactoryGirl.create(:bs_user, organization:bs)}

  describe "GET :index" do
    context "ログイン中" do
      before(:each) do
        sign_in(bs_user)
      end

      it "should be success" do
        get :index
        response.should be_success
      end

      it "assigns @students" do
        get :index
        assigns(:students).should_not be_nil
      end

      it "生徒の所属先はログイン中のBSアカウントの所属先と同じ" do
        bs2 = FactoryGirl.create(:bs, name:"BS2")
        s1 = FactoryGirl.create(:active_student, user_name:"s1", organization:bs)
        s2 = FactoryGirl.create(:active_student, user_name:"s2", organization:bs2)

        get :index
        assigns(:students).should == [s1]
      end
    end
  end

  describe "GET :show" do
    context "ログイン中" do
      before(:each) do
        sign_in bs_user
      end

      it "assigns @student" do
        student = FactoryGirl.create(:active_student, user_name:"s1", organization:bs)
        get :show, id:student
        assigns(:student).should be_a(Student)
      end
    end
  end

end

# encoding:utf-8
require 'spec_helper'

describe Pa::StudentsController do
  before(:each) do
    @parent = FactoryGirl.create(:parent, status: 'active')
  end

  describe "GET :new" do
    context "ログインしていない" do
      it "redirects to sign in page" do
        post :new
        response.should redirect_to(new_user_session_path)
      end
    end

    context "保護者としてログイン中" do
      before(:each) do
        sign_in :user, @parent
      end

      it "assigns @student" do
        get :new
        assigns(:student).should be_a(Student)
      end
    end
  end

  describe "POST :create" do

    context "ログインしていない" do
      it "redirects to sign in page" do
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end

    context "保護者としてログイン中" do
      let(:student) { mock_model(Student).as_null_object }
      before(:each) do
        sign_in :user, @parent
      end

      it "creates Student" do
        Student.should_receive(:new).and_return(student)

        post :create
      end

      it "作成した生徒の課金設定ページにリダイレクトされる" do
        Student.should_receive(:new).and_return(student)

        post :create
        response.should redirect_to(edit_pa_student_charge_path(student))
      end

      it "作成された生徒は保護者に関連付けられる" do
        student_attrs = FactoryGirl.attributes_for(:student)
        address_attrs = FactoryGirl.attributes_for(:address)

        post :create, student:student_attrs,
             address:address_attrs,
             student_info:{grade_id:Grade.first.id},
             user_operating_system: FactoryGirl.attributes_for(:user_operating_system)

        Parent.find(@parent.id).students.should have(1).item
      end
    end
  end

  describe "GET :show" do
    context "ログインしていない" do
      it "redirects to sign in page" do
        get :show, id:1
        response.should redirect_to(new_user_session_path)
      end
    end

    context "保護者としてログイン中" do
      before(:each) do
        sign_in :user, @parent
      end

      context "子供を登録済み" do
        it "子供の情報を見ることができる" do
          @parent.students << FactoryGirl.build(:active_student)
          get :show, id:@parent.students.last
          assigns(:student).should be_a(Student)
        end
      end
    end
  end

end

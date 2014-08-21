# coding:utf-8
require 'spec_helper'

describe Hq::BsAppFormsController do
  before(:each) do
    sign_in HqUser.first
  end

  describe "POST :create_user" do
    let(:form){FactoryGirl.create(:bs_app_form)}

    it "リダイレクトする" do
      post :create_user, id:form
      response.should redirect_to(registered_hq_bs_app_form_path(form))
    end

    it "BSを作成する" do
      expect {
        post :create_user, id:form
      }.to change(Bs, :count).by(1)
    end

    it "BsUserを作成する" do
      expect {
        post :create_user, id:form
      }.to change(BsUser, :count).by(1)
    end

    it "作成されるBsUserは新たに作られたBSに所属する" do
      post :create_user, id:form
      bs = Bs.last
      bs_user = BsUser.last
      bs_user.organization.should == bs
    end

    it "セッションにユーザ名とパスワードをセットする" do
      post :create_user, id:form
      session[:new_bs_user].should_not be_nil
      session[:new_bs_user][:user_name].should_not be_nil
      session[:new_bs_user][:password].should_not be_nil
    end

    it "作成されたBSとひもづけられる" do
      post :create_user, id:form.id

      BsAppForm.find(form.id).bs.should == Bs.last
    end
  end
end

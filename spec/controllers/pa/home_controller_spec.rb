# encoding: utf-8
require 'spec_helper'

describe Pa::HomeController do

  describe "GET :index" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトする" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end

    context "保護者としてログインしている場合" do
      it "成功する" do
        user = FactoryGirl.create(:active_parent)
        sign_in :user, user
        get :index
        response.should be_success
      end
    end
  end

end

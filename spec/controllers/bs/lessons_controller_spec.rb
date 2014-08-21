# encoding:utf-8
require 'spec_helper'

describe Bs::LessonsController do

  describe "GET index" do
    context "ログイン中" do
      before(:each) do
        bs = FactoryGirl.create(:bs)
        bs_user = FactoryGirl.create(:bs_user, organization:bs)
        sign_in(bs_user)
      end

      it "successを返す" do
        get :index
        response.should be_success
      end

      it "@lessonsに値を割り当てる" do
        get :index
        assigns(:lessons).should_not be_nil
      end
    end
  end
end

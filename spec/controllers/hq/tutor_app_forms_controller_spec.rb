# coding:utf-8
require 'spec_helper'

describe Hq::TutorAppFormsController do
  describe "POST :create_tutor" do
    context "管理者としてログイン中" do
      let(:admin){HqUser.first}
      before(:each) do
        sign_in admin
      end

      it "チューターを作成する" do
        tutor_app_form = FactoryGirl.create(:tutor_app_form)
        expect {
          get :create_tutor, id:tutor_app_form
        }.to change(Tutor, :count).by(1)
      end
    end
  end
end

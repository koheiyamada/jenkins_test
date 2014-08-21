# coding:utf-8
require 'spec_helper'

describe Gu::HomeController do

  context 'ログイン済' do
    let(:guest){Guest.first}

    before(:each) do
      sign_in guest
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should redirect_to(gu_tutors_path)
      end
    end

  end
end

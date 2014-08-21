# coding:utf-8
require 'spec_helper'

describe UserRegistrationForm do
  describe "作成" do
    it "メアド必須" do
      FactoryGirl.build(:user_registration_form, email:nil).should be_invalid
    end

    it "確認トークンを生成する" do
      form = FactoryGirl.create(:user_registration_form)
      form.confirmation_token.should_not be_nil
    end
  end
end

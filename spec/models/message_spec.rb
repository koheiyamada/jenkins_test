# encoding:utf-8
require 'spec_helper'

describe Message do
  let(:hq_user) {HqUser.first}
  let(:bs_user) {FactoryGirl.create(:bs_user)}

  it "送り主、宛先１件以上、タイトル、本文があればOK" do
    FactoryGirl.build(:message, sender:hq_user, recipients:[bs_user]).should be_valid
  end

  it "送り主が必須" do
    FactoryGirl.build(:message, sender:nil, recipients:[bs_user]).should be_invalid
  end

  it "送信先が必須" do
    FactoryGirl.build(:message, sender:hq_user, recipients:[]).should be_invalid
  end
end

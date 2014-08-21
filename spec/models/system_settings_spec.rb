# encoding:utf-8
require 'spec_helper'

describe SystemSettings do
  before(:each) do
    SystemSettings.destroy_all
  end

  it "シングルトン" do
    s1 = FactoryGirl.create(:system_settings)
    s1.should be_valid
    s2 = FactoryGirl.build(:system_settings)
    expect {
      s2.save
    }.to raise_error
  end
end

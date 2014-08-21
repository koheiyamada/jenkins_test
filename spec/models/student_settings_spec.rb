# encoding:utf-8
require 'spec_helper'

describe StudentSettings do
  it "の月々の課金上限の規定値は 50000円" do
    StudentSettings.create!.max_charge.should == 50000
  end
end

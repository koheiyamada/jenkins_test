# coding: utf-8
require 'spec_helper'

describe ChargeSettings do
  it '入会金は20000円' do
    ChargeSettings.entry_fee.should == 20000
  end
end

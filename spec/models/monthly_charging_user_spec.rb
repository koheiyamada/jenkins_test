# coding:utf-8

require 'spec_helper'

describe MonthlyChargingUser do
  describe '.calculate' do
    it 'Delayed::Jobを返す' do
      job = MonthlyChargingUser.calculate(2013, 11)
      job.should be_a(Delayed::Job)
    end
  end
end

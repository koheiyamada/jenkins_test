# coding:utf-8
require 'spec_helper'

describe Hq::Students::MonthlyStatementsController do
  describe 'access_controlled_resource' do
    it ':accountingを返す' do
      Hq::Students::MonthlyStatementsController.access_controlled_resource.should == :accounting
    end
  end
end

# coding:utf-8

require 'spec_helper'

describe AreaCode do
  it 'コードが必要' do
    AreaCode.new(code: nil).should_not be_valid
    AreaCode.new(code: '').should_not be_valid
    AreaCode.new(code: 'a').should be_valid
  end
end

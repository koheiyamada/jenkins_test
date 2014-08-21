# coding:utf-8

require 'spec_helper'

describe ZipCode do
  describe 'create' do
    it 'フォーマットはxxx-xxxx' do
      ZipCode.new(code: '123-4567').should be_valid
      ZipCode.new(code: '123-456').should_not be_valid
    end
  end

  describe 'normalize' do
    it '1234566は123-4567になる' do
      ZipCode.normalize('1234567').should == '123-4567'
    end

    it '123456は012-3456になる' do
      ZipCode.normalize('123456').should == '012-3456'
    end

    it '7桁以下の数値は文字列に変換される' do
      ZipCode.normalize(1234567).should == '123-4567'
      ZipCode.normalize(123456).should == '012-3456'
      ZipCode.normalize(12345).should == '001-2345'
    end
  end
end

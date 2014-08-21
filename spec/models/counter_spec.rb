# coding:utf-8
require 'spec_helper'

describe Counter do
  subject{Counter.find_or_create_by_key('test')}

  describe '#next' do
    it '1からはじまる' do
      subject.next.should == 1
    end

    it '呼び出すたびに1ずつ増える' do
      (1..10).each do |i|
        subject.next.should == i
      end
    end

    it '２つの同じキーのカウンターが同時に動作してもカウントは同期される' do
      counter2 = Counter.find_or_create_by_key('test')
      (1..10).each do |i|
        subject.next.should == 2 * i - 1
        counter2.next.should == 2 * i
      end
    end
  end

  describe '.next' do
    it '1からはじまる' do
      Counter.next('hoge').should == 1
    end

    it '呼び出すたびに1ずつ増える' do
      (1..10).each do |i|
        Counter.next('hoge').should == i
      end
    end
  end
end

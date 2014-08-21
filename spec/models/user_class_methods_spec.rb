# coding:utf-8
require 'spec_helper'

describe 'User class methods' do

  describe '.generate_user_name' do
    describe 'Tutor.generate_user_name' do
      it 'tで始まる' do
        Tutor.generate_user_name.should match(/\At/)
      end

      it '現在の西暦の下二桁が続く' do
        yy = Date.today.year % 100
        Tutor.generate_user_name.should match(Regexp.new "\\A.#{yy}")
      end

      it '全体で7桁' do
        Tutor.generate_user_name.length.should == 7
      end

      it '4桁目以降は英数字のみ' do
        100.times.each do
          Tutor.generate_user_name[3..-1].should match(/\A[A-Za-z0-9]{4}\Z/)
        end
      end
    end

    describe 'Student.generate_user_name' do
      it 'uで始まる' do
        Student.generate_user_name.should match(/\Au/)
      end

      it '現在の西暦の下二桁が続く' do
        yy = Date.today.year % 100
        Student.generate_user_name.should match(Regexp.new "\\A.#{yy}")
      end

      it '全体で7桁' do
        Student.generate_user_name.length.should == 7
      end

      it '4桁目以降は英数字のみ' do
        100.times.each do
          Student.generate_user_name[3..-1].should match(/\A[A-Za-z0-9]{4}\Z/)
        end
      end
    end

    describe 'BsUser.generate_user_name' do
      it 'bで始まる' do
        BsUser.generate_user_name.should match(/\Ab/)
      end

      it '現在の西暦の下二桁が続く' do
        yy = Date.today.year % 100
        BsUser.generate_user_name.should match(Regexp.new "\\A.#{yy}")
      end

      it '全体で7桁' do
        BsUser.generate_user_name.length.should == 7
      end

      it '4桁目以降は英数字のみ' do
        100.times.each do
          BsUser.generate_user_name[3..-1].should match(/\A[A-Za-z0-9]{4}\Z/)
        end
      end
    end

    describe 'HqUser.generate_user_name' do
      it 'hで始まる' do
        HqUser.generate_user_name.should match(/\Ah/)
      end

      it '現在の西暦の下二桁が続く' do
        yy = Date.today.year % 100
        HqUser.generate_user_name.should match(Regexp.new "\\A.#{yy}")
      end

      it '全体で7桁' do
        HqUser.generate_user_name.length.should == 7
      end

      it '4桁目以降は英数字のみ' do
        100.times.each do
          HqUser.generate_user_name[3..-1].should match(/\A[A-Za-z0-9]{4}\Z/)
        end
      end
    end

    describe 'Parent.generate_user_name' do
      it 'pで始まる' do
        Parent.generate_user_name.should match(/\Ap/)
      end

      it '現在の西暦の下二桁が続く' do
        yy = Date.today.year % 100
        Parent.generate_user_name.should match(Regexp.new "\\A.#{yy}")
      end

      it '全体で7桁' do
        Parent.generate_user_name.length.should == 7
      end

      it '4桁目以降は英数字のみ' do
        100.times.each do
          Parent.generate_user_name[3..-1].should match(/\A[A-Za-z0-9]{4}\Z/)
        end
      end
    end
  end
end
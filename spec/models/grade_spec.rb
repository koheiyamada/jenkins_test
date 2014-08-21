# coding: utf-8
require 'spec_helper'

describe Grade do
  it "16個ある" do
    Grade.all.should have(16).items
  end

  describe '通常の学年一式' do
    it "14個ある" do
      Grade.normal.should have(14).items
    end
  end

  describe '学年が上がる' do
    it '小学３年生から浪人生まで順繰りでつながっている' do
      %w(es3 es4 es5 es6 jh1 jh2 jh3 hs1 hs2 hs3 prep).each_cons(2) do |g1, g2|
        Grade.find_by_code(g1).next_grade.should == Grade.find_by_code(g2)
      end
    end
  end
end

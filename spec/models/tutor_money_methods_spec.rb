# coding:utf-8
require 'spec_helper'

describe TutorMoneyMethods do
  let(:student){FactoryGirl.create(:student)}

  describe 'lesson_fee_for_student' do
    context '現役仮登録チューターの場合' do
      before(:each) do
        @tutor = FactoryGirl.create(:tutor)
        @tutor.should be_beginner
      end

      [
        {premium:   0, fee: 1155},
        {premium:  50, fee: 1225},
        {premium: 100, fee: 1260},
        {premium: 200, fee: 1365},
      ].each do |config|
        it "学年割増が #{config[:premium]} なら授業料は #{config[:fee]}円" do
          student.stub(:grade_premium).and_return(config[:premium])
          @tutor.lesson_fee_for_student(student).should == config[:fee]
        end
      end
    end

    context '現役本登録チューターの場合' do
      before(:each) do
        @tutor = FactoryGirl.create(:tutor)
        @tutor.become_regular!
        @tutor.should be_regular
      end

      [
        {premium:   0, fee: 1650},
        {premium:  50, fee: 1750},
        {premium: 100, fee: 1800},
        {premium: 200, fee: 1950},
      ].each do |config|
        it "学年割増が #{config[:premium]} なら授業料は #{config[:fee]}円" do
          student.stub(:grade_premium).and_return(config[:premium])
          @tutor.lesson_fee_for_student(student).should == config[:fee]
        end
      end
    end

    context 'チューターが既卒の場合' do
      before(:each) do
        Tutor.any_instance.stub(:graduated?){true}
        @tutor = FactoryGirl.create(:tutor)
        @tutor.should be_beginner
      end

      context '既卒仮登録チューターの場合' do
        [
          {premium:   0, fee: 1435},
          {premium:  50, fee: 1505},
          {premium: 100, fee: 1540},
          {premium: 200, fee: 1645},
        ].each do |config|
          it "学年割増が #{config[:premium]} なら授業料は #{config[:fee]}円" do
            student.stub(:grade_premium).and_return(config[:premium])
            @tutor.lesson_fee_for_student(student).should == config[:fee]
          end
        end
      end

      context '既卒本登録チューターの場合' do
        before(:each) do
          @tutor.become_regular!
          @tutor.should be_regular
        end

        [
          {premium:   0, fee: 2050},
          {premium:  50, fee: 2150},
          {premium: 100, fee: 2200},
          {premium: 200, fee: 2350},
        ].each do |config|
          it "学年割増が #{config[:premium]} なら授業料は #{config[:fee]}円" do
            student.stub(:grade_premium).and_return(config[:premium])
            @tutor.lesson_fee_for_student(student).should == config[:fee]
          end
        end
      end
    end
  end

  describe '#lesson_unit_wage_for_student ある受講者を一コマ教えたときの賃金（レッスンとは違う）' do
    context '現役仮登録チューターの場合' do
      before(:each) do
        @tutor = FactoryGirl.create(:tutor)
        @tutor.should be_beginner
      end

      [
        {premium:   0, fee: 675},
        {premium:  50, fee: 675},
        {premium: 100, fee: 675},
        {premium: 200, fee: 675},
      ].each do |config|
        it "学年割増が #{config[:premium]} なら授業料は #{config[:fee]}円" do
          student.stub(:grade_premium).and_return(config[:premium])
          @tutor.lesson_unit_wage_for_student(student).should == config[:fee]
        end
      end
    end

    context '現役本登録チューターの場合' do
      before(:each) do
        @tutor = FactoryGirl.create(:tutor)
        @tutor.become_regular!
        @tutor.should be_regular
      end

      [
        {premium:   0, fee: 937},
        {premium:  50, fee: 975},
        {premium: 100, fee: 1012},
        {premium: 200, fee: 1087},
      ].each do |config|
        it "学年割増が #{config[:premium]} なら授業料は #{config[:fee]}円" do
          student.stub(:grade_premium).and_return(config[:premium])
          @tutor.lesson_unit_wage_for_student(student).should == config[:fee]
        end
      end
    end
  end
end
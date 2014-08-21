# encoding:utf-8
require 'spec_helper'

describe Exam do
  before(:each) do
    @subject = FactoryGirl.create(:subject)
    @admin = HqUser.first
    @month = Date.today.beginning_of_month
    @grade = Grade.first
  end

  def valid_attrs
    {subject:@subject, creator:@admin, month:@month, grade:@grade, duration: 50}
  end

  describe "create!" do
    it "適切なパラメータがあれば作成できる" do
      Exam.new(valid_attrs).should be_valid
    end

    it "作成者が要る" do
      attrs = valid_attrs
      attrs.delete(:creator)
      Exam.new(attrs).should_not be_valid
    end

    context "monthが与えられている" do
      it "受験可能開始時間がセットされる" do
        attrs = valid_attrs
        exam = Exam.create!(attrs)
        exam.beginning_of_term.should be_present
      end

      it "受験可能終了時間がセットされる" do
        attrs = valid_attrs
        Exam.create!(attrs).end_of_term.should be_present
      end
    end

    it "試験時間が要る" do
      attrs = valid_attrs
      attrs.delete(:duration)
      Exam.new(attrs).should_not be_valid
    end
  end
end

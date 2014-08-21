# coding:utf-8
require 'spec_helper'

describe BeginnerTutor do
  it '仮登録から本登録になることができる' do
    beginner = FactoryGirl.create(:beginner_tutor)
    beginner.should be_a(BeginnerTutor)
    tutor = beginner.becomes(Tutor)
    tutor.save!
    Tutor.find(tutor.id).should_not be_a(BeginnerTutor)
  end

  it '本登録から仮登録に戻すこともできる' do
    tutor = FactoryGirl.create(:tutor)
    tutor.update_attribute(:type, BeginnerTutor.name)
    Tutor.find(tutor.id).should be_a(BeginnerTutor)
  end
end

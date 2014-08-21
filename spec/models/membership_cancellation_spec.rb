# coding:utf-8

require 'spec_helper'

describe MembershipCancellation do
  around(:each) do |test|
    Delayed::Worker.delay_jobs = false
    test.call
    Delayed::Worker.delay_jobs = true
  end

  let(:student) {FactoryGirl.create(:student)}
  let(:parent) {FactoryGirl.create(:parent)}

  describe '.create' do
    it 'ユーザーはログインできなくなる' do
      expect {
        m = MembershipCancellation.create(user: student, reason: 'hello')
        m.should be_persisted
      }.to change{Student.find(student.id).active_for_authentication?}.from(true).to(false)
    end

    it 'ユーザーが退会状態に移行する' do
      expect {
        m = MembershipCancellation.create(user: student, reason: 'hello')
        m.should be_persisted
      }.to change{student.left?}.from(false).to(true)
    end
  end

  describe '#execute' do
    context 'ユーザーが退会できない状態の場合' do
      it 'エラー状態になる' do
        m = MembershipCancellation.create(user: student, reason: 'hello')
        m.should be_persisted

        errors = ['hoge', 'fuga']
        m.stub(:user){student}
        student.stub(:leave){false}
        student.stub_chain(:errors, :full_messages){errors}
        m.execute
        m.should be_error

        m.error_messages.should be_present
        m.error_messages.should == errors
      end
    end
  end
end

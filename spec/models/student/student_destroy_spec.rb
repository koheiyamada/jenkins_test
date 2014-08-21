# coding:utf-8

require 'spec_helper'

describe Student do
  subject{FactoryGirl.create(:active_student)}

  before(:each) do
    subject.create_membership_cancellation(reason: 'Hello')
  end

  it '退会オブジェクトが減る' do
    expect {
      subject.destroy
    }.to change(MembershipCancellation, :count).by(-1)
  end
end
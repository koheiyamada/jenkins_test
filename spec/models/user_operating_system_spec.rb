# coding:utf-8

require 'spec_helper'

describe UserOperatingSystem do
  let(:student) {FactoryGirl.create(:active_student)}

  it 'その他を選ぶと名前がいる' do
    os = mock_model(OperatingSystem)
    os.stub(:unknown?){true}

    user_os = student.build_user_operating_system do |uos|
      uos.operating_system = os
    end
    user_os.should_not be_valid

    user_os.build_custom_operating_system(name: 'hoge')
    user_os.should be_valid
  end
end

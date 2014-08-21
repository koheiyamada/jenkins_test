# coding:utf-8

FactoryGirl.define do
  factory :special_tutor do
    sequence(:user_name) {|n| 'special_tutor%02d' % n}
    email 'shimokawa@soba-project.com'
    password 'password'
    first_name 'Taro'
    last_name 'SpecialTutor'
    nickname "すぺしゃるちゅーた"
    organization {Headquarter.instance}
    association :info, :factory => :tutor_info
  end
end

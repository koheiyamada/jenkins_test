# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :beginner_tutor do
    sequence(:user_name) {|n| "btutor%02d" % n}
    email "shimokawa@soba-project.com"
    password "password"
    first_name "Taro"
    last_name "Tutor"
    nickname "ちゅーた"
    association :info, :factory => :tutor_info
  end
end

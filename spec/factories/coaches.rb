# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coach do
    sequence(:user_name) {|n| 'c13%04d' % n}
    email 'shimokawa@soba-project.com'
    password 'password'
    first_name 'Coach'
    last_name 'Taro'
    first_name_kana 'こーち'
    last_name_kana 'たろー'
    sequence(:nickname) {|n| "こーち_#{n}"}
    sex 'male'
    association :organization, :factory => :bs
  end
end

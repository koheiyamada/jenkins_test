# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bs_user do
    user_name "shimokawa_bs_user"
    email "shimokawa@soba-project.com"
    password "password"
    first_name "Bees"
    last_name "Taro"
    first_name_kana 'びーえす'
    last_name_kana 'たろー'
    association :organization, :factory => :bs
    sex 'male'
    birth_place 'Tokyo'
  end
end

# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :yucho_account do
    kigo1 "12345"
    kigo2 "1"
    bango "12345678"
    account_holder_name '下川拓治'
    account_holder_name_kana 'シモカワタクジ'
  end
end

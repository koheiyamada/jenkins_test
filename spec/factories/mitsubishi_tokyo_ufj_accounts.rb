# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mitsubishi_tokyo_ufj_account do
    branch_name 'Kyoto'
    branch_code '123'
    account_number '123456789'
    account_holder_name '下川拓治'
    account_holder_name_kana 'シモカワタクジ'
  end
end

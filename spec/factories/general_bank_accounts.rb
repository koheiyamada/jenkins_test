# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :general_bank_account do
    branch_name "京都支店"
    branch_code "123"
    account_type 'savings'
    account_number "1234567890"
    account_holder_name "下川拓治"
    account_holder_name_kana "シモカワタクジ"
  end
end

#-*- encoding: utf-8 -*-#
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :temp_yucho_account do
    kigo1 "11111"
    kigo2 ""
    bango "12345678"
    account_holder_name '斉藤はじめ'
    account_holder_name_kana 'サイトウハジメ'
  end
end

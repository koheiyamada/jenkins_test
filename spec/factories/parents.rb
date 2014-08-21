# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :parent do
    sequence(:user_name) {|n| "papa%02d" % n}
    email "shimokawa@soba-project.com"
    last_name "保護者"
    first_name "太郎"
    last_name_kana 'ほごしゃ'
    first_name_kana 'たろう'
    password "papapassword"
    phone_number "111-1111-1111"
    address
    #status 'active'
    sex 'male'
    payment_method {CreditCardPayment.new}

    factory :parent_with_credit_card do
      has_credit_card true
    end

    factory :active_parent do
      status 'active'
    end
  end
end

# encoding:utf-8

FactoryGirl.define do
  factory :student do
    sequence(:user_name) {|n| "student%02d" % n}
    password "password"
    email "shimokawa@soba-project.com"
    sequence(:nickname) {|n| "ponyo_#{n}"}
    first_name "太郎"
    last_name "生徒"
    first_name_kana "Taro"
    last_name_kana "Seito"
    phone_number "111-1111-1111"
    birthday 15.years.ago.to_date
    phone_email "shimokawa@soba-project.com"
    gmail "takuji.shimokawa@gmail.com"
    address
    sex 'male'
    payment_method {CreditCardPayment.new}
    student_info

    factory :student_with_credit_card do
      has_credit_card true
    end

    factory :active_student do
      status 'active'
    end
  end
end

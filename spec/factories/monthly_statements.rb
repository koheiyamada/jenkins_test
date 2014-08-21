# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :monthly_statement do
    owner nil
    year 1
    month 1
    amount_of_payment 0
    amount_of_money_received 0
    paid false
  end
end

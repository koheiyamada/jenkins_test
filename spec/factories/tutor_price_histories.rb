# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_price_history do
    tutor nil
    hourly_wage 1
  end
end

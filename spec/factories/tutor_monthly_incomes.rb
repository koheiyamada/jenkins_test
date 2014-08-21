# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_monthly_income do
    tutor ""
    year 1
    month 1
    current_amount 1
    expected_amount 1
  end
end

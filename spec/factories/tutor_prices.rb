# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_price do
    tutor nil
    hourly_wage 900
  end
end

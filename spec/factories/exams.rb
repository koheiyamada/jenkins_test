# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exam do
    grade {Grade.first}
    subject
    month {Date.today}
    creator {HqUser.first}
    duration 60
  end
end

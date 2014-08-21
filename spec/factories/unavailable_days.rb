# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unavailable_day do
    tutor nil
    date "2012-10-29"
  end
end

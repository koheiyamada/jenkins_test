# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_daily_lesson_skip do
    tutor nil
    date "2013-02-15"
    count 1
  end
end

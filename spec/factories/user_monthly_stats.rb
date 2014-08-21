# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_monthly_stat do
    user nil
    year 2012
    month 1
    optional_lesson_cancellation_count 0
    basic_lesson_cancellation_count 0
  end
end

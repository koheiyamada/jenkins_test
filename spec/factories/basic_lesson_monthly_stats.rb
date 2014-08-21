# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :basic_lesson_monthly_stat do
    basic_lesson nil
    tutor_schedule_change_count 1
  end
end

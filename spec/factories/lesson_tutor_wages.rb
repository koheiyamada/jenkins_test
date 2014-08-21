# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_tutor_wage do
    lesson nil
    wage 1
    group_lesson_premium false
  end
end

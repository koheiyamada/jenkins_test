# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_lesson_cancellation do
    lesson nil
    reason 'Busy'
  end
end

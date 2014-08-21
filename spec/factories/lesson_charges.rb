# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_charge do
    lesson_student nil
    fee 1000
  end
end

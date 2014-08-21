# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_extendability do
    lesson nil
    extendable false
    reason "MyString"
  end
end

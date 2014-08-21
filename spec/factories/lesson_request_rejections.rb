# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_request_rejection do
    lesson nil
    user nil
    reason "MyString"
  end
end

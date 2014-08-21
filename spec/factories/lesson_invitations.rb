# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_invitation do
    lesson nil
    student nil
    status "MyString"
  end
end

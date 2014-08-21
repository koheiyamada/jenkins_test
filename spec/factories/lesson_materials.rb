# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_material do
    owner_id 1
    owner_type "MyString"
    lesson_id ""
  end
end

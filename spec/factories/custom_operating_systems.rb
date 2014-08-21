# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_operating_system do
    user_operating_system nil
    name "MyString"
  end
end

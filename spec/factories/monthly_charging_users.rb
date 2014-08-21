# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :monthly_charging_user do
    year 1
    month 1
    user nil
    user_type "MyString"
    user_name "MyString"
    full_name "MyString"
  end
end

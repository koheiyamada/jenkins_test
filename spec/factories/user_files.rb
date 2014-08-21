# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_file do
    user nil
    file "MyString"
  end
end

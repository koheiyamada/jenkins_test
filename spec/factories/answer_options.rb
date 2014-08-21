# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer_option do
    question nil
    code "MyString"
  end
end

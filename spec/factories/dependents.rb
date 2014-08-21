# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dependent do
    parent nil
    student nil
  end
end

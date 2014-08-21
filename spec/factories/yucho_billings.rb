# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :yucho_billing do
    yucho_account nil
    amount 1
  end
end

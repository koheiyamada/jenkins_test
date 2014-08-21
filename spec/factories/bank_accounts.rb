# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bank_account do
    owner_id nil
    owner_type nil
    account_id nil
    account_type nil
  end
end

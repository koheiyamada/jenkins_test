# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hq_yucho_payment do
    yucho_account nil
    monthly_statement nil
    amount 1
  end
end

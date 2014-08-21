# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_hq_user_reference_discount, :class => 'Account::HqUserReferenceDiscount' do
    association :owner, :factory => :student
    amount_of_money_received 100
    year Date.today.year
    month Date.today.month
  end
end

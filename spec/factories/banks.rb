# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bank do
    sequence(:code) {|n| "bank_#{n}"}
    sequence(:name) {|n| "BANK #{n}"}
  end
end

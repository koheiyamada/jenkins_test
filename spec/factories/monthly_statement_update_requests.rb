# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :monthly_statement_update_request do
    owner_id 1
    owner_type "MyString"
    year 1
    month 1
  end
end

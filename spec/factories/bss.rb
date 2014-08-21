# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bs do
    name "new bs"
    email "shimokawa@soba-project.com"
    phone_number "111-1111-1111"
    address
    area_code "027-007"
  end
end

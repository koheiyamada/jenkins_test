# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_registration_form do
    user nil
    email "shimokawa@soba-project.com"
    adsl false
    os_id 1
  end
end

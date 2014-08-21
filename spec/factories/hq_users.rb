# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hq_user do
    sequence(:user_name) {|n| "hq_user%d" % n}
    password "password"
    email 'shimokawa@soba-project.com'
    admin true
  end
end

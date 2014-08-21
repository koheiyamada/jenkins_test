# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge_setting, :class => 'ChargeSettings' do
    name "MyString"
    amount 1
  end
end

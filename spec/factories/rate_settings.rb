# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rate_setting, :class => 'RateSettings' do
    name "MyString"
    rate 1.5
  end
end

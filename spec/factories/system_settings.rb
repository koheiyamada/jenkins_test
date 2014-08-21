# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_settings, :class => 'SystemSettings' do
    entry_fee 1
    message_storage_period 1
  end
end

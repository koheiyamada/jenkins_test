# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meeting_member do
    meeting nil
    user nil
    prefered_schedule nil
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trial_lesson do
    tutor
    start_time {2.hour.from_now}
    units 1
  end
end

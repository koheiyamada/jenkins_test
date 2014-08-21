# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :optional_lesson do
    tutor
    start_time {2.hour.from_now}
    end_time { start_time ? 45.minutes.since(start_time) : nil}
  end
end

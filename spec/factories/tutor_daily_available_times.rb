# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_daily_available_time do
    tutor
    start_at {Time.current}
    end_at {60.minutes.since start_at}
  end
end

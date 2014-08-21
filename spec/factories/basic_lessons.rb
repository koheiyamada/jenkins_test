# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :basic_lesson do
    start_time {1.month.from_now}
    end_time { start_time ? 45.minutes.since(start_time) : nil}

    #association :course, :factory => :basic_lesson_info
  end
end

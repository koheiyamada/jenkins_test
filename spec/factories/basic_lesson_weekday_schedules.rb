# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :basic_lesson_weekday_schedule, :class => 'BasicLessonWeekdaySchedule' do
    basic_lesson_info nil
    start_time { Time.zone.now }
    end_time nil
    units 1
  end
end

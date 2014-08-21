# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :basic_lesson_info do
    tutor nil #association :tutor, :factory => :tutor
    subject nil #association :subject, :factory => :subject
    final_day nil

    now = Time.zone.now
    schedules {[BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)]}

    factory :basic_lesson_info_with_a_student do
      association :tutor, :factory => :tutor_with_weekday_schedule
      after(:create) do |basic_lesson_info, evaluator|
        basic_lesson_info.students << FactoryGirl.create(:active_student)
      end
    end
  end
end

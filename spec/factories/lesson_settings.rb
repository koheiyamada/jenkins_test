# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lesson_setting, :class => 'LessonSettings' do
    tutor_entry_period_before_start_time 1
    tutor_entry_period_after_start_time 1
    student_entry_period_before_start_time 1
    student_entry_period_after_start_time 1
    student_entry_period_after_end_time 1
    dropout_limit 1
  end
end

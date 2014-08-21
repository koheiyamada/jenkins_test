# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_student do
    tutor nil
    student nil
    lesson_report false
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_info do
    grade_id {Grade.first.id}
  end
end

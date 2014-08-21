# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_favorite_tutor do
    student nil
    tutor nil
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teaching_subject do
    tutor nil
    subject nil
    level 1
  end
end

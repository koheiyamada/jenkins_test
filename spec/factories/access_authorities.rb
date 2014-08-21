# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :access_authority do
    hq_user 1
    bs_user 1
    tutor 1
    parent 1
    accounting 1
    cs_sheet 1
    lesson_report 1
  end
end

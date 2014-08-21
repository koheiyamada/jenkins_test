# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meeting_report do
    meeting nil
    author nil
    text "MyText"
  end
end

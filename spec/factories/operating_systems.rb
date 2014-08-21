# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :operating_system do
    name "MyString"
    windows_experience_index_score_available false
  end
end

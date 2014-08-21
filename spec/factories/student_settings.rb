# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_setting, :class => 'StudentSettings' do
    student nil
    max_charge 1
  end
end

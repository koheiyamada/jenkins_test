# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_operating_system do
    #user nil
    operating_system_id {OperatingSystem.first.id}
  end
end

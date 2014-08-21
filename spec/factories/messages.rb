# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    sender nil
    title "This is a title"
    text "Hello, my name is Tom!"
  end
end

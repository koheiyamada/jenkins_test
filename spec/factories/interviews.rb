# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :interview do
    user1 nil
    user2 nil
    start_time "2012-10-02 11:24:27"
    end_time "2012-10-02 11:24:27"
    note "MyText"
  end
end

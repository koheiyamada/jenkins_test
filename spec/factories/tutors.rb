# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor do
    sequence(:user_name) {|n| "tutor%02d" % n}
    email "shimokawa@soba-project.com"
    password "password"
    first_name "Taro"
    last_name "Tutor"
    sequence(:nickname) {|n| "ちゅーた_#{n}"}
    organization {Headquarter.instance}
    association :info, :factory => :tutor_info

    factory :tutor_with_weekday_schedule do
      user_name "scheduled_tutor"
      email "shimokawa2@soba-project.com"
      last_name "ScheduledTutor"
      after(:create) do |tutor, evaluator|
        t = Time.zone.now
        tutor.add_weekday_schedule(t.beginning_of_day, t.end_of_day)
      end
    end
  end
end

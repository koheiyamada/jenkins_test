# encoding:utf-8

FactoryGirl.define do
  factory :lesson_report do
    lesson nil
    author nil
    content "これはレッスンレポートの中身です。\n内容は特にありません。"
    lesson_content "mathmatics"
    homework_result "good"
    understanding "perfect"
    word_to_student "hi!"
  end
end

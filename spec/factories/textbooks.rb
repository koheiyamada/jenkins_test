# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :textbook do
    title 'MyString'
    pages 1
    direction 'right'
    double_pages false
    dir {Rails.root.join('spec/fixtures/textbook/book1')}
    sequence(:textbook_id) {|n| n}
  end
end

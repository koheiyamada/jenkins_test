# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :area_code do
    sequence(:code) {|n| '%03d-%03d' % [n / 1000, n % 1000]}
  end
end

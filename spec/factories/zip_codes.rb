# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :zip_code do
    sequence(:code) {|n| '%03d-%04d' % [n / 10000, n % 10000]}
  end
end

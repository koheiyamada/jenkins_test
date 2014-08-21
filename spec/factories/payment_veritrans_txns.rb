# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_veritrans_txn do
    user nil
    order_id "MyString"
  end
end

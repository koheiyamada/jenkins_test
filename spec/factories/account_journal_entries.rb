# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_journal_entry, :class => 'Account::JournalEntry' do
    amount_of_payment 0
    year  {Date.today.year}
    month {Date.today.month}
  end
end

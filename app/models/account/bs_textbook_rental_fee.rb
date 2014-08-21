class Account::BsTextbookRentalFee < Account::JournalEntry
  belongs_to :student
  attr_accessible :student
end

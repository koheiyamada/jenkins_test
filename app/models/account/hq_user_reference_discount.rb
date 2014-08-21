class Account::HqUserReferenceDiscount < Account::JournalEntry
  validates_uniqueness_of :month, :scope => [:year, :owner_id]
end

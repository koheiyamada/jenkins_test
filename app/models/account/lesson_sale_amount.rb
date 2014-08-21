class Account::LessonSaleAmount < Account::JournalEntry
  validates_uniqueness_of :owner_id, :scope => [:year, :month], :if => :payee?
end

class Account::Exam2Fee < Account::JournalEntry
  amount_given
  to_headquarter

  validates_uniqueness_of :owner_id, :scope => [:year, :month], :if => :payer?
end

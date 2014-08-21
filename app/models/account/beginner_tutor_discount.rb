class Account::BeginnerTutorDiscount < Account::JournalEntry
  belongs_to :student
  attr_accessible :student

  validates_uniqueness_of :owner_id, :scope => :lesson_id, :if => :payee?
end

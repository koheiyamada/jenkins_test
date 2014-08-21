class Account::GroupLessonPremium < Account::JournalEntry
  validates_presence_of :lesson_id
  validates_uniqueness_of :owner_id, :scope => :lesson_id, :if => :payee?
end

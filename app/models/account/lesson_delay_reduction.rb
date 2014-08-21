class Account::LessonDelayReduction < Account::JournalEntry
  validates_presence_of :lesson_id
  validates_uniqueness_of :lesson_id, :scope => [:owner_id, :owner_type], :on => :create
end

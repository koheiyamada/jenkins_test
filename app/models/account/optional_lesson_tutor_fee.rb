class Account::OptionalLessonTutorFee < Account::JournalEntry
  validates_presence_of :lesson_id
  validates_uniqueness_of :lesson_id, :scope => [:owner_id, :owner_type], :on => :create, :if => :payee?

  before_save do
    month = lesson.tutor_wage_month
    self.year = month.year
    self.month = month.month
  end
end

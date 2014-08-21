class Account::BasicLessonFee < Account::JournalEntry
  belongs_to :student
  attr_accessible :lesson, :student

  validates_presence_of :lesson_id, :organization_id
  validates_uniqueness_of :lesson_id, :scope => [:owner_id, :owner_type], :if => :payer?, :on => :create
end

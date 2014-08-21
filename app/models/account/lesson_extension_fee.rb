class Account::LessonExtensionFee < Account::JournalEntry
  validates_presence_of :lesson_id
  validates_uniqueness_of :lesson_id, :scope => [:owner_id, :owner_type], :if => :payer?, :on => :create
  validate :payer_is_attendee, :if => :payer?

  private

  def payer_is_attendee
    if payer? && lesson && !lesson.students.include?(owner)
      errors.add(:owner, :not_lesson_member)
    end
  end
end

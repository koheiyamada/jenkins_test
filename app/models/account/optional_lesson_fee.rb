class Account::OptionalLessonFee < Account::JournalEntry
  belongs_to :student
  attr_accessible :student, :note2, :original_lesson_fee

  validates_presence_of :lesson_id, :organization_id
  validates_uniqueness_of :lesson_id, :scope => [:owner_id, :owner_type], :if => :payer?, :on => :create

  validate :ensure_student_is_lesson_member

  def free?
   lesson.free?
  end

  private

    def ensure_student_is_lesson_member
      if student && lesson && !lesson.students.include?(student)
        errors.add(:student_id, :not_lesson_member)
      end
    end
end

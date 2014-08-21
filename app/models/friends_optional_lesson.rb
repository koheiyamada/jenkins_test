class FriendsOptionalLesson < OptionalLesson
  include InvitableLesson

  after_initialize do
    self.is_group_lesson = true
  end

  #validates_presence_of :friend_id, :if => :member_check_required?

  def shared_lesson?
    false
  end

  def friends_lesson?
    true
  end

  def have_enough_students?
    students.count > 1
  end

  def style
    if started? && !group_lesson?
      :single
    else
      :friends
    end
  end

  def max_student_count
    2
  end

  def can_add_student?(student)
    !students.include?(student) && invited_student?(student)
  end

  def add_student(student)
    if invited_student? student
      lesson_invitation.accept
      lesson_invitation.errors.empty?
    else
      errors.add(:students, :cannot_add)
      false
    end
  end

  def all_members_attended?
    if lesson_invitation.responded?
      super
    else
      logger.debug 'NOT ALL MEMBER ATTENDED BECAUSE INVITED STUDENT HAS NEVER RESPONDED YET!'
      false
    end
  end

  private

  def member_check_required?
    fixed? && !have_enough_students?
  end
end

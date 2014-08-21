class SharedOptionalLesson < OptionalLesson

  after_initialize do
    self.is_group_lesson = true
    self.friend_id = nil
  end

  def shared_lesson?
    true
  end

  def friends_lesson?
    false
  end

  def have_enough_students?
    students.count > 0
  end

  def style
    if started? && !group_lesson?
      :single
    else
      :shared
    end
  end

  def max_student_count
    2
  end
end

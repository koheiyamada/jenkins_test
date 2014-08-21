class FriendsBasicLessonInfo < BasicLessonInfo

  def student_acceptable?(student)
    if fixed?
      students.include?(student) || possible_students.include?(student)
    else
      true
    end
  end

  def friends_lesson?
    true
  end

  def shared_lesson?
    false
  end

  def can_have_multiple_students?
    true
  end

  def style
    :friends
  end

  def max_students_count
    2
  end

  def min_students_count
    2
  end
end

class SharedBasicLessonInfo < BasicLessonInfo

  def student_acceptable?(student)
    if students.include?(student)
      false
    else
      !full?
    end
  end

  def friends_lesson?
    false
  end

  def shared_lesson?
    true
  end

  def can_have_multiple_students?
    true
  end

  def style
    :shared
  end

  def max_students_count
    2
  end

  def min_students_count
    1
  end
end

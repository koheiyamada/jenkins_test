module LessonStudentsHelper
  def lesson_student_attended_at(lesson_student)
    if lesson_student.attended_at.present?
      l lesson_student.attended_at, format: :promise
    else
      nil
    end
  end
end